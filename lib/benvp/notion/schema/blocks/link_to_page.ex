defmodule Benvp.Notion.Schema.Blocks.LinkToPage do
  @enforce_keys [
    :type
  ]

  defstruct [
    :type,
    :page_id,
    :database_id
  ]

  @type t :: %__MODULE__{
          type: :page_id | :database_id,
          page_id: String.t() | nil,
          database_id: String.t() | nil
        }
end
