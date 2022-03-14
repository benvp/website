defmodule Benvp.Notion.Schema.Blocks.Callout do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :icon,
    :text
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          text: list(Schema.Blocks.RichText.t()),
          icon: Schema.File.t() | Schema.Emoji.t()
        }
end
