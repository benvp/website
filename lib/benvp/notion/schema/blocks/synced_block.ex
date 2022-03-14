defmodule Benvp.Notion.Schema.Blocks.SyncedBlock do
  alias Benvp.Notion.Schema

  defstruct [
    :synced_from
  ]

  @type t :: %__MODULE__{
          synced_from:
            %{
              block_id: Schema.id()
            }
            | nil
        }
end
