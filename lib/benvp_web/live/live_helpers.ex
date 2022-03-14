defmodule BenvpWeb.LiveHelpers do
  import Phoenix.LiveView

  def truncate(string, length \\ 30)
  def truncate(nil, _length), do: ""

  def truncate(string, length) do
    if String.length(string) > length do
      string =
        string
        |> String.slice(0, length)
        |> String.trim_trailing()

      string <> "..."
    else
      string
    end
  end
end
