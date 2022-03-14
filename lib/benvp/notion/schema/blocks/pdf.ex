defmodule Benvp.Notion.Schema.Blocks.PDF do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :pdf
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          pdf: Schema.File.t()
        }
end
