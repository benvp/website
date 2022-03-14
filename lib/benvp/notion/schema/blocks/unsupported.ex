defmodule Benvp.Notion.Schema.Blocks.Unsupported do
  @enforce_keys [
    :type
  ]

  defstruct [
    :type
  ]

  @type t :: %__MODULE__{
          type: :unsupported
        }
end
