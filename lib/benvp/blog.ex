defmodule Benvp.Blog do
  alias Benvp.Blog.{Cache, Post}

  def get_latest_posts!(amount \\ 3) do
    Cache.get(:latest_posts, fn -> fetch_latest_posts(amount) end)
  end

  def get_post_by_slug!(slug) do
    Cache.get({:posts, slug}, fn -> fetch_post_by_slug(slug) end)
  end

  defp fetch_latest_posts(amount) do
    {:ok, posts} =
      notion_client().query_database(database_id(), %{
        page_size: amount,
        filter: %{
          property: "Status",
          select: %{
            equals: "Published"
          }
        },
        sorts: [
          %{
            property: "Published At",
            direction: "descending"
          }
        ]
      })

    Enum.map(posts, &populate_post/1)
  end

  defp fetch_post_by_slug(slug) do
    {:ok, posts} =
      notion_client().query_database(database_id(), %{
        filter: %{
          and: [
            %{
              property: "Status",
              select: %{
                equals: "Published"
              }
            },
            %{
              property: "Slug",
              rich_text: %{
                equals: slug
              }
            }
          ]
        }
      })

    populate_post(List.first(posts))
  end

  defp populate_post(post) do
    {:ok, content} = notion_client().get_block(post["id"], recursive: true)
    Post.from_notion(post, content)
  end

  defp notion_client, do: Application.fetch_env!(:benvp, :notion_client)
  defp database_id, do: Application.fetch_env!(:benvp, :notion_blog_database_id)
end
