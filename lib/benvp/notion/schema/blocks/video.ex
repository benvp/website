defmodule Benvp.Notion.Schema.Blocks.Video do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :video
  ]

  defstruct @enforce_keys

  @type t :: %__MODULE__{
          video: Schema.File.t()
        }
end
