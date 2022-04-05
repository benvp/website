defmodule LiveMotion do
  use Phoenix.Component

  alias LiveMotion.Motion

  def animate(keyframes, transition \\ %{}, exit_keyframes \\ %{}) do
    %Motion{
      keyframes: Enum.into(keyframes, %{}),
      transition: Enum.into(transition, %{}),
      exit: Enum.into(exit_keyframes, %{})
    }
    |> translate_easing()
  end

  def motion(assigns) do
    rest = assigns_to_attributes(assigns, [:animate, :transition, :initial, :exit])

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
      |> assign_new(:animate, fn -> [] end)
      |> assign_new(:transition, fn -> [] end)
      |> assign_new(:exit, fn -> [] end)
      |> assign(:style, initial)
      |> assign(:rest, rest)

    ~H"""
    <div
      id={@id}
      phx-hook="Motion"
      data-motion={LiveMotion.animate(@animate, @transition, @exit)}
      phx-remove={LiveMotion.JS.hide(to: @id)}
      style={@style}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp translate_easing(%Motion{transition: %{easing: [spring: opts]}} = motion) do
    Map.update!(motion, :transition, fn transition ->
      transition
      |> Map.put(:__easing, [:spring, Enum.into(opts, %{})])
      |> Map.delete(:easing)
    end)
  end

  defp translate_easing(%Motion{} = motion), do: motion
end
