defmodule LiveMotion do
  alias LiveMotion.Motion

  def animate(keyframes, transition \\ %{}) do
    %Motion{
      keyframes: Enum.into(keyframes, %{}),
      transition: Enum.into(transition, %{})
    }
    |> translate_easing()
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
