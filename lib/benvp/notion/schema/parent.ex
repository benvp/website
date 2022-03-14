defmodule Benvp.Notion.Schema.DatabaseParent do
  @enforce_keys [
    :type,
    :database_id
  ]

  defstruct [
    :type,
    :database_id
  ]

  @type t :: %__MODULE__{
          type: :database_id,
          database_id: String.t()
        }
end

defmodule Benvp.Notion.Schema.PageParent do
  @enforce_keys [
    :type,
    :page_id
  ]

  defstruct [
    :type,
    :page_id
  ]

  @type t :: %__MODULE__{
          type: :page_id,
          page_id: String.t()
        }
end

defmodule Benvp.Notion.Schema.WorkspaceParent do
  @enforce_keys [
    :type,
    :workspace
  ]

  defstruct [
    :type,
    :workspace
  ]

  @type t :: %__MODULE__{
          type: :page_id,
          workspace: boolean()
        }
end
