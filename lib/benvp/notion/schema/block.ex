defmodule Benvp.Notion.Schema.Block do
  alias Benvp.Notion.Schema

  @enforce_keys [
    :object,
    :id,
    :type,
    :created_time,
    :last_edited_time,
    :archived,
    :has_children,
    :children
  ]

  defstruct [
    :object,
    :id,
    :type,
    :created_time,
    :last_edited_time,
    :archived,
    :has_children,
    :children,
    :paragraph,
    :heading_1,
    :heading_2,
    :heading_3,
    :bulleted_list_item,
    :numbered_list_item,
    :to_do,
    :toggle,
    :child_page,
    :child_database,
    :embed,
    :image,
    :video,
    :file,
    :pdf,
    :bookmark,
    :callout,
    :quote,
    :equation,
    :divider,
    :table_of_contents,
    :column,
    :column_list,
    :link_preview,
    :synced_block,
    :template,
    :link_to_page,
    :unsupported
  ]

  @type block_type ::
          :paragraph
          | :heading_1
          | :heading_2
          | :heading_3
          | :bulleted_list_item
          | :numbered_list_item
          | :to_do
          | :toggle
          | :child_page
          | :child_database
          | :embed
          | :image
          | :video
          | :file
          | :pdf
          | :bookmark
          | :callout
          | :quote
          | :equation
          | :divider
          | :table_of_contents
          | :column
          | :column_list
          | :link_preview
          | :synced_block
          | :template
          | :link_to_page
          | :unsupported

  @type t :: %__MODULE__{
          object: :block,
          id: Schema.id(),
          type: block_type(),
          created_time: DateTime.t(),
          last_edited_time: DateTime.t(),
          archived: boolean(),
          has_children: boolean(),
          children: list(),
          paragraph: map(),
          heading_1: map(),
          heading_2: map(),
          heading_3: map(),
          bulleted_list_item: map(),
          numbered_list_item: map(),
          to_do: map(),
          toggle: map(),
          child_page: map(),
          child_database: map(),
          embed: map(),
          image: map(),
          video: map(),
          file: map(),
          pdf: map(),
          bookmark: map(),
          callout: map(),
          quote: map(),
          equation: map(),
          divider: map(),
          table_of_contents: map(),
          column: map(),
          column_list: map(),
          link_preview: map(),
          synced_block: map(),
          template: map(),
          link_to_page: map(),
          unsupported: map()
        }
end
