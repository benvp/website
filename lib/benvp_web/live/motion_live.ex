defmodule BenvpWeb.MotionLive do
  use BenvpWeb, :live_view

  alias LiveMotion

  def mount(_params, _session, socket) do
    {:ok, assign(socket, x: 100)}
  end

  def handle_event("change", _params, socket) do
    {:noreply, assign(socket, x: Enum.random(1..400))}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center flex-col">
      <div class="flex justify-center items-center my-24">

        <.motion
          initial={[ y: -50, opacity: 0, scale: 2 ]}
          animate={[ y: 0, opacity: 1, scale: 1, x: [nil, @x] ]}
          transition={[easing: [spring: [stiffness: 20, damping: 5]]]}
        >
          <div class="h-24 w-24 bg-benvp-green"></div>
        </.motion>


      </div>

      <button class="mt-4" phx-click="change"}>
        Animate me!
      </button>

    </div>
    """
  end

  def motion(assigns) do
    rest = assigns_to_attributes(assigns, [:animate, :transition, :initial])

    initial =
      case assigns[:initial] do
        nil ->
          nil

        initial ->
          (initial || assigns.animate)
          |> LiveMotion.Style.create_styles()
          |> LiveMotion.Style.to_style_string()
      end

    assigns =
      assigns
      |> assign(:style, initial)
      |> assign(:rest, rest)

    ~H"""
    <div id="foo"
      phx-hook="Motion"
      data-motion={LiveMotion.animate(@animate, @transition)}
      style={@style}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
