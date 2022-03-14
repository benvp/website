defmodule Benvp.Notion.Schema.Blocks.Bookmark do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :url,
    :caption
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          url: String.t(),
          caption: list(Schema.Blocks.RichText.t())
        }
end
