defmodule BenvpWeb.MotionLive do
  use BenvpWeb, :live_view

  alias LiveMotion.JS, as: MotionJS

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-12 max-w-screen-md m-auto flex justify-center space-y-4 flex-col items-center">
      <div class="my-4 flex justify-center">
        <LiveMotion.motion
          id="rectangle"
          class="w-24 h-24 bg-benvp-green rounded-lg"
          exit={[opacity: 0, y: -20]}
        >
        </LiveMotion.motion>
      </div>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={
          MotionJS.toggle(
            [
              in: [opacity: 1, y: 0],
              out: [opacity: 0, y: -20]
            ],
            [],
            to: "#rectangle"
          )
        }
      >
        Toggle Square
      </button>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={MotionJS.hide(to: "#rectangle")}
      >
        Hide Square
      </button>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={MotionJS.show(to: "#love-div", keyframes: [opacity: 1, y: 20])}
      >
        Show some love
      </button>

      <LiveMotion.motion
        id="love"
        class="my-4 justify-center hidden"
        defer
        initial={[y: 20, opacity: 0]}
        animate={[y: 0, opacity: 1]}
      >
        <div class="text-4xl">❤️</div>
      </LiveMotion.motion>

      <div id="love-div" class="my-4 justify-center hidden opacity-0">
        <div class="text-4xl">❤️</div>
      </div>
    </div>
    """
  end
end
