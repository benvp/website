defmodule BenvpWeb.MotionLive do
  use BenvpWeb, :live_view

  require Logger

  alias LiveMotion.JS, as: MotionJS

  def mount(_params, _session, socket) do
    {:ok, assign(socket, visible: true, rotate: 0)}
  end

  def handle_event("update", _params, socket) do
    rotate = if socket.assigns.rotate == 0, do: 360, else: 0
    {:noreply, assign(socket, rotate: rotate)}
  end

  def handle_event("remove", _params, socket) do
    {:noreply, assign(socket, visible: false)}
  end

  def handle_event("animation_start", _params, socket) do
    Logger.debug("Animation started")
    {:noreply, socket}
  end

  def handle_event("animation_complete", _params, socket) do
    Logger.debug("Animation completed")
    {:noreply, socket}
  end

  def handle_event("some_push", _params, socket) do
    Logger.debug("Random push event")
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-12 max-w-screen-md m-auto flex justify-center space-y-4 flex-col items-center">
      <div class="my-4 flex justify-center">
        <%= if @visible do %>
          <LiveMotion.motion
            id="rectangle"
            class="w-24 h-24 bg-benvp-green rounded-lg"
            initial={[opacity: 0, y: -20, rotate: 0]}
            animate={[opacity: 1, y: 0, rotate: @rotate]}
            exit={[opacity: 0, y: -20]}
            on_animation_start="animation_start"
            on_animation_complete="animation_complete"
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
        phx-click={MotionJS.animate([y: [0, -20, 10, 0]], [duration: 1], to: "#rectangle")}
      >
        Animate Square (JS)
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

      <button type="button" class="px-4 py-2 bg-slate-800 rounded" phx-click="update">
        Update Square (Server)
      </button>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={MotionJS.show(to: "#love-div", keyframes: [opacity: 1, y: 20])}
      >
        Show some love (non motion div)
      </button>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={
          MotionJS.animate([rotate: [0, 45, -45, 90, 0]], [duration: 1], to: "#rectangle")
          |> MotionJS.show(to: "#love-div", keyframes: [opacity: 1, y: 20, rotate: 180])
          |> Phoenix.LiveView.JS.push("some_push")
        }
      >
        Composed JS actions
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
