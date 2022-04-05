defmodule BenvpWeb.MotionLive do
  use BenvpWeb, :live_view

  alias Phoenix.LiveView.JS
  alias LiveMotion

  @colors ["#FF5F57", "#FEBC2F", "#28C840", "#00FFBF", "#8710EB", "#FC6969"]

  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       rotate: 0,
       scale: 1,
       background: Enum.random(@colors),
       v: true
     )}
  end

  def handle_event("animate", _params, socket) do
    {:noreply,
     assign(socket,
       rotate: if(socket.assigns.rotate == 0, do: 360, else: 0),
       scale: if(socket.assigns.scale == 1, do: 1.5, else: 1),
       background: Enum.random(@colors)
     )}
  end

  def handle_event("remove", _params, socket) do
    {:noreply,
     assign(socket,
       v: false
     )}
  end

  # transition={[easing: [spring: [stiffness: 100, damping: 20]]]}
  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center flex-col">
    <div id="remove-me" class="flex justify-center items-center my-24" phx-remove={hide_modal()}>

          <%= if @v do %>
            <LiveMotion.motion
              id="foo"
              class="h-24 w-24 rounded-xl"
              initial={false}
              animate={[ rotate: @rotate, background: @background, scale: @scale]}
              transition={[easing: [spring: [stiffness: 100, damping: 20]]]}
              exit={[opacity: 0, y: -20]}
            >
              <button
                class="flex w-full h-full justify-center items-center fold-bold text-4xl"
                phx-click="animate"
              >
                🚀
              </button>
            </LiveMotion.motion>
          <% end %>
        </div>

      <!-- This toggles fully client side animations !-->
      <button
        class="mt-12 bg-blue px-4 py-2"
        phx-click={LiveMotion.JS.toggle(
          [
            in: [opacity: 1, y: [nil, -50, 0]],
            out: [opacity: 0, y: [nil, 50, 0]]
          ],
          [duration: 5],
          to: "#foo"
        )}
      >
        Toggle me
      </button>

      <button
        class="mt-12 bg-blue px-4 py-2"
        phx-click={LiveMotion.JS.hide(to: "#foo")}
      >
        Hide me browser
      </button>

      <button
        class="mt-12 bg-blue px-4 py-2"
        phx-click="remove"
      >
        Hide me server
      </button>

      <button
        class="mt-12 bg-blue px-4 py-2"
        phx-click="animate"
      >
        Animate me server
      </button>
    </div>
    """
  end

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(transition: "fade-out", to: "#remove-me", time: 2000)
  end
end
