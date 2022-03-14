defmodule Benvp.Notion.Schema.Blocks.Image do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :image
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          image: Schema.File.t()
        }
end
