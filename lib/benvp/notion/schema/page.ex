defmodule Benvp.Notion.Schema.Page do
  @moduledoc """
  Represents a page.
  """

  alias Benvp.Notion.Schema
  alias Benvp.Notion.Schema.{File, Emoji, Parent}

  @enforce_keys [
    :id,
    :object,
    :created_time,
    :last_edited_time,
    :archived,
    :icon,
    :properties,
    :parent,
    :url
  ]

  defstruct [
    :id,
    :object,
    :created_time,
    :last_edited_time,
    :archived,
    :icon,
    :cover,
    :properties,
    :parent,
    :url
  ]

  @type t :: %__MODULE__{
          id: Schema.id(),
          object: :page,
          created_time: DateTime.t(),
          last_edited_time: DateTime.t(),
          archived: boolean(),
          icon: File.t() | Emoji.t(),
          cover: File.t(),
          # TODO: Add proper type,
          properties: map(),
          parent: Parent.t(),
          url: String.t()
        }
end
