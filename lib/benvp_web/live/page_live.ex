defmodule BenvpWeb.PageLive do
  use BenvpWeb, :live_view

  alias Benvp.Blog

  def mount(_params, _session, socket) do
    posts = Blog.get_latest_posts!()
    {:ok, assign(socket, :posts, posts)}
  end

  def render(assigns) do
    ~H"""
    <div class="py-8 px-8 sm:px-16 lg:px-0 overflow-x-hidden">
      <div class="absolute inset-[0] lg:inset-[-40px] top-[320px] sm:top-[40px] lg:top-[280px] bg-[url('/images/bg-wave.svg')] bg-cover bg-center opacity-70 select-none -z-10"></div>

      <.hero />

      <section class="max-w-screen-md mx-auto mt-20 sm:mt-48">
        <.terminal />
      </section>

      <section class="max-w-screen-md mx-auto sm:grid sm:grid-cols-12 mt-40">
        <div class="sm:col-span-3">
          <.section_title title="Blog" />
        </div>
        <div class="mt-12 sm:mt-0 sm:col-start-5 sm:col-span-8 space-y-20">
          <%= for post <- @posts do %>
            <.blog_entry
              title={post.title}
              date={post.created_at}
              text={post.abstract}
              slug={post.slug || ""}
            />
          <% end %>
        </div>
      </section>
    </div>
    """
  end

  defp hero(assigns) do
    ~H"""
    <div class="mt-8 sm:mt-20 max-w-screen-md mx-auto text-white relative">
      <div class="relative -z-10">
        <div
          class="absolute bg-[url('/images/code-window.png')] bg-contain bg-center px-6 -mx-6 sm:px-0 sm:mx-0 bg-no-repeat top-[-50px] sm:top-[-90px] right-0 w-[250px] sm:w-[350px] h-[250px] sm:h-[350px]"
        ></div>

        <div class="absolute -z-20 w-[500px] h-[500px] top-[-140px] left-[-140px] bg-[url('/images/hero-aurora.png')] bg-cover bg-center"></div>
      </div>

      <div class="relative">
        <div class="p-5 w-28 h-28 flex justify-center items-center rounded-full bg-gray-800 z-10">
          <img src={Routes.static_path(BenvpWeb.Endpoint, "/images/me.png")} class="object-center object-contain select-none pointer-events-none" />
        </div>
      </div>

      <h1 class="mt-16 sm:mt-6 text-benvp-text text-4xl font-title font-bold leading-tight">
        Hey, I'm Ben.<span class="w-1.5 h-8 inline-block ml-2 bg-benvp-green"></span><br>
        I code <span class="text-benvp-red">React</span> daily, like pretty UIs<br>
        and have a passion for <span class="text-benvp-purple">Elixir</span>.
      </h1>
    </div>
    """
  end

  defp terminal(assigns) do
    assigns =
      assigns
      |> assign_new(:lines, fn -> [] end)

    ~H"""
    <div class="relative h-auto sm:h-[450px] -mx-8 sm:mx-0">
      <div class="absolute -z-10 w-full h-full sm:h-[120%] sm:w-[125%] sm:top-[-50px] sm:bottom-0 sm:left-[-100px] sm:right-0 bg-[url('/images/terminal-bg.png')] bg-cover bg-repeat-y sm:bg-no-repeat blur-2xl" />

      <div class="h-full flex items-center justify-center ff-backdrop-blur">
        <div class="flex-1 w-full h-full px-6 py-6 sm:py-5 backdrop-blur-[72px] sm:rounded-lg border border-white border-opacity-5">
          <div class="flex items-center">
            <div class="hidden sm:flex absolute space-x-2">
              <div class="rounded-full w-3 h-3 bg-close"></div>
              <div class="rounded-full w-3 h-3 bg-minimize"></div>
              <div class="rounded-full w-3 h-3 bg-maximize"></div>
            </div>

            <h2 class="flex-1 sm:text-center font-bold font-mono text-gray-200 text-sm">open source activity</h2>
          </div>

          <div class="pt-6 space-y-8">
            <.prompt title="2021/raycast_set_audio_device">
              <:line>
                <.terminal_line>Switch the active audio device of your Mac.</.terminal_line>
                <.terminal_line>
                  <a class="terminal-link" href="https://www.raycast.com/benvp/audio-device" rel="noreferrer" target="_blank">Raycast Store</a> | MIT License
                </.terminal_line>
              </:line>
            </.prompt>

            <.prompt title="2020/toniefy">
              <:line>
                <.terminal_line>listen spotify on your toniebox</.terminal_line>
                <.terminal_line>
                  <a class="terminal-link" href="https://github.com/benvp/toniefy" rel="noreferrer" target="_blank">GitHub</a> | MIT License
                </.terminal_line>
              </:line>
            </.prompt>

            <.prompt title="2019/vscode-hex-pm-intellisense">
              <:line>
                <.terminal_line>Adds IntelliSense for hex.pm dependencies in your Elixir project Mixfile.</.terminal_line>
                <.terminal_line>
                  <a class="terminal-link" href="https://github.com/benvp/vscode-hex-pm-intellisense" rel="noreferrer" target="_blank">GitHub</a> | MIT License
                </.terminal_line>
              </:line>
            </.prompt>

            <.terminal_line>
              <span class="inline-flex">
                <a class="font-mono terminal-link" href="https://github.com/benvp" rel="noreferrer">See all projects</a>
                <span class="w-2.5 h-5 inline-block ml-2 bg-teal-300"></span>
              </span>
            </.terminal_line>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp prompt(assigns) do
    assigns =
      assigns
      |> assign_new(:line, fn -> [] end)

    ~H"""
    <div class="font-mono text-sm sm:text-base leading-relaxed">
      <p class="break-all"><span class="mr-2 select-none">🚀</span><%= @title %></p>
      <%= render_slot(@line) %>
    </div>
    """
  end

  defp terminal_line(assigns) do
    ~H"""
    <p class="font-mono break-before-right">
      <span class="select-none">~</span><span class="ml-2 select-none">#</span><span class="ml-2 select-none">➜</span>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  defp section_title(assigns) do
    ~H"""
    <div>
      <h2 class="font-title text-4xl font-bold"><%= @title %></h2>
      <img class="ml-2 -mt-2 w-[150px]" src={Routes.static_path(BenvpWeb.Endpoint, "/images/blog-decoration.svg")} />
    </div>
    """
  end

  defp blog_entry(assigns) do
    ~H"""
    <article>
      <h2><%= live_redirect @title, to: Routes.live_path(BenvpWeb.Endpoint, BenvpWeb.PostLive, @slug), class: "font-bold text-2xl underline decoration-2 decoration-benvp-green" %></h2>
      <p class="text-gray-400"><%= Calendar.strftime(@date, "%c") %></p>
      <p class="mt-3"><%= truncate(@text, 200) %></p>
    </article>
    """
  end
end
