defmodule Benvp.Notion.Schema.Blocks.LinkPreview do
  @enforce_keys [
    :url
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          url: String.t()
        }
end
