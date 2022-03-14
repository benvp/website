defmodule Benvp.Notion.Schema.Blocks.ChildDatabase do
  @enforce_keys [
    :title
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          title: String.t()
        }
end
