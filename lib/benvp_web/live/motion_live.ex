defmodule BenvpWeb.MotionLive do
  use BenvpWeb, :live_view

  alias LiveMotion.JS, as: MotionJS

  def mount(_params, _session, socket) do
    {:ok, assign(socket, visible: true)}
  end

  def handle_event("remove", _params, socket) do
    {:noreply, assign(socket, visible: false)}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-12 max-w-screen-md m-auto flex justify-center space-y-4 flex-col items-center">
      <div class="my-4 flex justify-center">
        <%= if @visible do %>
          <LiveMotion.motion
            id="rectangle"
            class="w-24 h-24 bg-benvp-green rounded-lg"
            initial={[opacity: 0, y: -20]}
            animate={[opacity: 1, y: 0]}
            exit={[opacity: 0, y: -20]}
          >
          </LiveMotion.motion>
        <% end %>
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
        Hide Square (JS)
      </button>

      <button type="button" class="px-4 py-2 bg-slate-800 rounded" phx-click="remove">
        Hide Square (Server)
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
