defmodule Benvp.Blog.Post do
  @moduledoc """
  A blog post.
  """

  @enforce_keys [:title, :created_at, :status]
  defstruct [:title, :created_at, :status, :published_at, :abstract, :slug, :raw_content]

  @typedoc "A blog post"
  @type t() :: %__MODULE__{
          title: String.t(),
          created_at: DateTime.t(),
          status: :draft | :published,
          published_at: DateTime.t() | nil,
          abstract: String.t() | nil,
          slug: String.t() | nil,
          raw_content: map() | nil
        }

  @spec from_notion(map(), map() | nil) :: __MODULE__.t()
  def from_notion(db_object, content \\ nil) do
    %__MODULE__{
      title: get_property_value(db_object, "Name"),
      created_at: get_property_value(db_object, "Created"),
      status: get_property_value(db_object, "Status"),
      published_at: get_property_value(db_object, "Published At"),
      abstract: get_property_value(db_object, "Abstract"),
      slug: get_property_value(db_object, "Slug"),
      raw_content: content
    }
  end

  defp get_property_value(db_object, name) do
    type = get_property_type(db_object, name)
    get_property_value(db_object, name, type)
  end

  defp get_property_value(db_object, name, "title" = type) do
    db_object
    |> get_in(["properties", name, type])
    |> List.first()
    |> get_in(["text", "content"])
  end

  defp get_property_value(db_object, name, "created_time" = type) do
    db_object
    |> get_in(["properties", name, type])
    |> DateTime.from_iso8601()
    |> elem(1)
  end

  defp get_property_value(db_object, name, "date" = type) do
    db_object
    |> get_in(["properties", name, type, "start"])
    |> DateTime.from_iso8601()
    |> elem(1)
  end

  defp get_property_value(db_object, name, "rich_text" = type) do
    db_object
    |> get_in(["properties", name, type])
    |> List.first()
    |> case do
      nil -> nil
      value when is_map(value) -> value["plain_text"]
    end
  end

  defp get_property_value(db_object, "Status" = name, "select" = type) do
    db_object
    |> get_in(["properties", name, type, "name"])
    |> case do
      "Published" -> :published
      "Draft" -> :draft
    end
  end

  defp get_property_type(db_object, name) do
    get_in(db_object, ["properties", name, "type"])
  end
end
