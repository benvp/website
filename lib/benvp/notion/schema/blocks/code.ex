defmodule Benvp.Notion.Schema.Blocks.Code do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :text,
    :language
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          text: list(Schema.Blocks.RichText.t()),
          language: String.t()
        }
end
