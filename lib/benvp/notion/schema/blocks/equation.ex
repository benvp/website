defmodule Benvp.Notion.Schema.Blocks.Equation do
  @enforce_keys [
    :expression
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          expression: String.t()
        }
end
