defmodule Benvp.Notion.Schema.Blocks.ToDo do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :text,
    :checked
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          text: list(Schema.Blocks.RichText.t()),
          checked: boolean()
        }
end
