defmodule Benvp.Notion.Schema.Blocks.File do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :file
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          file: Schema.File.t()
        }
end
