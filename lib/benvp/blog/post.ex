defmodule Benvp.Blog.Post do
  @moduledoc """
  A blog post.
  """
  alias Benvp.Blog.Post
  alias Benvp.Notion

  @enforce_keys [:id, :title, :created_at, :status]

  defstruct [
    :id,
    :title,
    :created_at,
    :status,
    :published_at,
    :abstract,
    :slug,
    :image_url,
    :social_image_url,
    :raw_content
  ]

  @typedoc "A blog post"
  @type t() :: %__MODULE__{
          id: String.t(),
          title: String.t(),
          created_at: DateTime.t(),
          status: :draft | :published,
          published_at: DateTime.t() | nil,
          abstract: String.t() | nil,
          slug: String.t() | nil,
          image_url: String.t() | nil,
          social_image_url: String.t() | nil,
          raw_content: map() | nil
        }

  @spec from_notion(map(), map() | nil) :: __MODULE__.t()
  def from_notion(db_object, content \\ nil) do
    %__MODULE__{
      id: db_object["id"],
      title: get_property_value(db_object, "Name"),
      created_at: get_property_value(db_object, "Created"),
      status: get_property_value(db_object, "Status"),
      published_at: get_property_value(db_object, "Published At"),
      abstract: get_property_value(db_object, "Abstract"),
      slug: get_property_value(db_object, "Slug"),
      image_url: get_property_value(db_object, "Image"),
      social_image_url: get_property_value(db_object, "Social Image"),
      raw_content: content
    }
  end

  @doc """
  Download the notion cover image url and replace it with a public url.
  """
  def maybe_download_property_images(post) when is_nil(post.image_url), do: post

  def maybe_download_property_images(post) do
    download = fn url, suffix ->
      filename = build_filename(url, suffix)
      {_dest, public_url} = Notion.save_media!(url, filename)
      public_url
    end

    %Post{
      post
      | image_url: download.(post.image_url, "_#{String.slice(post.id, 0..7)}_cover"),
        social_image_url:
          download.(post.social_image_url, "_#{String.slice(post.id, 0..7)}_social")
    }
  end

  @doc """
  Traverse all children and download all media (currently only images are supported)
  so they are publicly available and don't rely on notions expiring link.
  """
  @spec maybe_download_media(Post.t()) :: Post.t()
  def maybe_download_media(%Post{} = post) do
    %Post{post | raw_content: download_block_media(post.raw_content, post.id)}
  end

  defp download_block_media(%{"type" => "image", "image" => image} = block, id) do
    Map.put(block, "image", download_block_media(image, id))
  end

  defp download_block_media(%{"type" => "file", "file" => file} = block, id) do
    filename = build_filename(file["url"], "_#{String.slice(id, 0..7)}")
    {_dest, public_url} = Notion.save_media!(file["url"], filename)

    put_in(block, ["file", "url"], public_url)
  end

  defp download_block_media(%{"_children" => children} = block, id) do
    Map.put(block, "_children", Enum.map(children, &download_block_media(&1, id)))
  end

  defp download_block_media(block, _id), do: block

  defp build_filename(url, suffix) do
    url
    |> URI.parse()
    |> Map.fetch!(:path)
    |> then(&Path.basename(&1, Path.extname(&1)))
    |> Kernel.<>(suffix)
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

  defp get_property_value(db_object, name, "files" = type) do
    db_object
    |> get_in(["properties", name, type])
    |> List.first()
    |> get_in(["file", "url"])
  end

  defp get_property_type(db_object, name) do
    get_in(db_object, ["properties", name, "type"])
  end
end
