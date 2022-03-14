defmodule Benvp.Notion.Schema.Blocks.Embed do
  @enforce_keys [
    :url
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          url: String.t()
        }
end
