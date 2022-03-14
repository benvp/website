defmodule Benvp.Notion.Schema.File do
  @enforce_keys [
    :type
  ]

  defstruct [
    :type,
    :file,
    :external
  ]

  @type t :: %__MODULE__{
          type: :file | :external,
          file: map(),
          external: %{url: String.t()}
        }
end
