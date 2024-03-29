# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian instead of
# Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20210902-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.13.2-erlang-24.2-debian-bullseye-20210902-slim
#
ARG BUILDER_IMAGE="hexpm/elixir:1.13.2-erlang-24.2-debian-bullseye-20210902-slim"
ARG RUNNER_IMAGE="debian:bullseye-20210902-slim"

FROM ${BUILDER_IMAGE} as builder

ARG NOTION_MEDIA_DIR=/app/media

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git curl bash \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# install node 16
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash \
    && apt-get install -y nodejs

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# We need to set this here because Plug options need to
# be available at compilation time. We can't use runtime.exs
# for this variable.
ENV NOTION_MEDIA_DIR=${NOTION_MEDIA_DIR}

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv

# note: if your project uses a tool like https://purgecss.com/,
# which customizes asset compilation based on what it finds in
# your Elixir templates, you will need to move the asset compilation
# step down so that `lib` is available.
COPY assets assets

# Compile the release
COPY lib lib

# compile assets
RUN mix assets.setup
RUN mix assets.deploy

RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales curl \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"

RUN addgroup --system --gid 1024 beam
RUN adduser --system --uid 1024 phoenix
RUN usermod -aG beam phoenix

RUN chown phoenix:beam /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=phoenix:beam /app/_build/${MIX_ENV}/rel/benvp ./

USER phoenix

EXPOSE 3000

CMD ["/app/bin/server"]
