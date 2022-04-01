defmodule LiveMotion.Utils do
  def to_kebab_case(string) do
    string
    |> String.downcase()
    |> String.split(~r/_/)
    |> Enum.join("-")
  end
end
