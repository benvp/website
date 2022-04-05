defmodule LiveMotion.JS do
  alias Phoenix.LiveView.JS

  def animate(keyframes, transition, opts) do
    opts = Keyword.merge(opts, detail: build_dispatch_detail(keyframes, transition))
    JS.dispatch("live_motion:animate", opts)
  end

  def toggle(keyframes, transition, opts) do
    opts =
      Keyword.merge(opts,
        detail: %{
          keyframes: %{
            in: Enum.into(keyframes[:in], %{}),
            out: Enum.into(keyframes[:out], %{})
          },
          transition: Enum.into(transition, %{})
        }
      )

    JS.dispatch("live_motion:toggle", opts)
  end

  def hide(opts) do
    JS.dispatch("live_motion:hide", detail: Enum.into(opts, %{}))
  end

  defp build_dispatch_detail(keyframes, transition) do
    %{
      keyframes: Enum.into(keyframes, %{}),
      transition: Enum.into(transition, %{})
    }
  end
end
