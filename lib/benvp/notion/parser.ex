defmodule Benvp.Notion.Parser do
  @moduledoc """
  Provides logic for parsing results returned from the Notion API.
  """

  alias Benvp.Notion.Schema

  def parse_page(object) do
    {:ok, created_time, _} = DateTime.from_iso8601(object["created_time"])
    {:ok, last_edited_time, _} = DateTime.from_iso8601(object["last_edited_time"])

    %Schema.Page{
      id: object["id"],
      object: :page,
      created_time: created_time,
      last_edited_time: last_edited_time,
      archived: object["archived"],
      icon: parse_icon(object["icon"]),
      cover: object["cover"],
      properties: object["properties"],
      parent: parse_parent(object["parent"]),
      url: object["url"]
    }
  end

  def parse_icon(%{"type" => "emoji"} = object), do: parse_emoji(object)
  def parse_icon(object), do: parse_file(object)

  defp parse_emoji(object) do
    %Schema.Emoji{
      type: :emoji,
      emoji: object["emoji"]
    }
  end

  defp parse_file(%{"type" => "file"} = object) do
    %Schema.File{
      type: :file,
      file: %{
        expiry_time: object["file"]["expiry_time"],
        url: object["file"]["url"]
      }
    }
  end

  defp parse_file(%{"type" => "external"} = object) do
    %Schema.File{
      type: :external,
      external: %{
        url: object["external"]["url"]
      }
    }
  end

  def parse_parent(%{"type" => "database_id"} = object), do: parse_database_parent(object)
  def parse_parent(%{"type" => "page_id"} = object), do: parse_page_parent(object)
  def parse_parent(%{"type" => "workspace"} = object), do: parse_workspace_parent(object)

  defp parse_database_parent(object) do
    %Schema.DatabaseParent{
      type: :database_id,
      database_id: object["database_id"]
    }
  end

  defp parse_page_parent(object) do
    %Schema.PageParent{
      type: :page_id,
      page_id: object["page_id"]
    }
  end

  defp parse_workspace_parent(object) do
    %Schema.WorkspaceParent{
      type: :workspace,
      workspace: object["workspace"]
    }
  end

  def parse_block(%{"object" => "block"} = object) do
    {:ok, created_time, _} = DateTime.from_iso8601(object["created_time"])
    {:ok, last_edited_time, _} = DateTime.from_iso8601(object["last_edited_time"])

    block = %Schema.Block{
      object: :block,
      id: object["id"],
      type: String.to_existing_atom(object["type"]),
      created_time: created_time,
      last_edited_time: last_edited_time,
      archived: object["archived"],
      has_children: object["has_children"],
      children: parse_children(object)
    }

    Map.put(block, block.type, parse_block_type(object))
  end

  def parse_block_type(%{"type" => "bookmark", "bookmark" => bookmark}) do
    %Schema.Blocks.Bookmark{
      url: bookmark["url"],
      caption: Enum.map(bookmark["caption"], &parse_rich_text/1)
    }
  end

  def parse_block_type(%{"type" => "breadcrumb"}) do
    %Schema.Blocks.Breadcrumb{}
  end

  def parse_block_type(%{
        "type" => "bulleted_list_item",
        "bulleted_list_item" => bulleted_list_item
      }) do
    %Schema.Blocks.BulletedListItem{
      text: Enum.map(bulleted_list_item["text"], &parse_rich_text/1)
    }
  end

  def parse_block_type(%{"type" => "callout", "callout" => callout} = object) do
    %Schema.Blocks.Callout{
      icon: parse_icon(object["icon"]),
      text: Enum.map(callout["text"], &parse_rich_text/1)
    }
  end

  def parse_block_type(%{"type" => "child_database", "child_database" => child_database}) do
    %Schema.Blocks.ChildDatabase{
      title: child_database["title"]
    }
  end

  def parse_block_type(%{"type" => "child_page", "child_page" => child_page}) do
    %Schema.Blocks.ChildPage{
      title: child_page["title"]
    }
  end

  def parse_block_type(%{"type" => "code", "code" => code}) do
    %Schema.Blocks.Code{
      text: Enum.map(code["text"], &parse_rich_text/1),
      language: code["language"]
    }
  end

  def parse_block_type(%{"type" => "column_list"}) do
    %Schema.Blocks.ColumnList{}
  end

  def parse_block_type(%{"type" => "column"}) do
    %Schema.Blocks.Column{}
  end

  def parse_block_type(%{"type" => "divider"}) do
    %Schema.Blocks.Divider{}
  end

  def parse_block_type(%{"type" => "embed", "embed" => embed}) do
    %Schema.Blocks.Embed{
      url: embed["url"]
    }
  end

  def parse_block_type(%{"type" => "equation", "equation" => equation}) do
    %Schema.Blocks.Equation{
      expression: equation["expression"]
    }
  end

  def parse_block_type(%{"type" => "file", "file" => file}) do
    %Schema.Blocks.File{
      file: parse_file(file)
    }
  end

  def parse_block_type(%{"type" => "heading_1", "heading_1" => heading}),
    do: parse_heading(heading)

  def parse_block_type(%{"type" => "heading_2", "heading_2" => heading}),
    do: parse_heading(heading)

  def parse_block_type(%{"type" => "heading_3", "heading_3" => heading}),
    do: parse_heading(heading)

  def parse_block_type(%{"type" => "image", "image" => image}) do
    %Schema.Blocks.Image{
      image: parse_file(image)
    }
  end

  def parse_block_type(%{"type" => "link_preview", "link_preview" => link_preview}) do
    %Schema.Blocks.LinkPreview{
      url: link_preview["url"]
    }
  end

  def parse_block_type(%{"type" => "link_to_page", "link_to_page" => link_to_page}) do
    type =
      if link_to_page["database_id"] do
        :database_id
      else
        :page_id
      end

    %Schema.Blocks.LinkToPage{
      type: type,
      page_id: link_to_page["page_id"],
      database_id: link_to_page["database_id"]
    }
  end

  def parse_block_type(%{
        "type" => "numbered_list_item",
        "numbered_list_item" => numbered_list_item
      }) do
    %Schema.Blocks.NumberedListItem{
      text: Enum.map(numbered_list_item["text"], &parse_rich_text/1)
    }
  end

  def parse_block_type(%{"type" => "paragraph", "paragraph" => paragraph}) do
    %Schema.Blocks.Paragraph{
      text: Enum.map(paragraph["text"], &parse_rich_text/1)
    }
  end

  def parse_block_type(%{"type" => "pdf", "pdf" => pdf}) do
    %Schema.Blocks.PDF{
      pdf: parse_file(pdf)
    }
  end

  def parse_block_type(%{"type" => "quote", "quote" => q}) do
    %Schema.Blocks.Quote{
      text: Enum.map(q["text"], &parse_rich_text/1)
    }
  end

  def parse_block_type(%{"type" => "synced_block", "synced_block" => synced_block}) do
    synced_from =
      if synced_block["synced_from"] do
        %{block_id: synced_block["synced_from"]["block_id"]}
      else
        nil
      end

    %Schema.Blocks.SyncedBlock{
      synced_from: synced_from
    }
  end

  def parse_block_type(%{"type" => "table_of_contents"}) do
    %Schema.Blocks.TableOfContents{}
  end

  def parse_block_type(%{"type" => "template", "template" => template}) do
    %Schema.Blocks.Template{
      text: Enum.map(template["text"], &parse_rich_text/1)
    }
  end

  def parse_block_type(%{"type" => "to_do", "to_do" => to_do}) do
    %Schema.Blocks.ToDo{
      text: Enum.map(to_do["text"], &parse_rich_text/1),
      checked: to_do["checked"]
    }
  end

  def parse_block_type(%{"type" => "toggle", "toggle" => toggle}) do
    %Schema.Blocks.Toggle{
      text: Enum.map(toggle["text"], &parse_rich_text/1)
    }
  end

  def parse_block_type(%{"type" => "unsupported"}) do
    %Schema.Blocks.Unsupported{
      type: :unsupported
    }
  end

  def parse_block_type(%{"type" => "video", "video" => video}) do
    %Schema.Blocks.Video{
      video: parse_file(video)
    }
  end

  def parse_heading(heading) do
    %Schema.Blocks.Heading{
      text: Enum.map(heading["text"], &parse_rich_text/1)
    }
  end

  def parse_rich_text(object) do
    %Schema.Blocks.RichText{
      plain_text: object["plain_text"],
      href: object["href"],
      annotations: %{
        bold: object["annotations"]["bold"],
        italic: object["annotations"]["italic"],
        strikethrough: object["annotations"]["strikethrough"],
        underline: object["annotations"]["underline"],
        code: object["annotations"]["code"],
        color: object["annotations"]["color"]
      },
      type:
        case object["type"] do
          "text" -> :text
          "mention" -> :mention
          "equation" -> :equation
        end
    }
  end

  defp parse_children(%{"children" => children}), do: Enum.map(children, &parse_block/1)
  defp parse_children(_object), do: []
end
