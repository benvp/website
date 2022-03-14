defmodule Benvp.Notion.Schema.Blocks.Heading do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :text
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          text: list(Schema.Blocks.RichText.t())
        }
end
