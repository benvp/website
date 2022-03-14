defmodule BenvpWeb.PostLive do
  use BenvpWeb, :live_view

  alias Benvp.Blog
  alias Benvp.Notion.Renderer

  def mount(%{"slug" => slug}, _session, socket) do
    post = Blog.get_post_by_slug!(slug)
    {:ok, assign(socket, :post, post)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.post post={@post} />
    </div>
    """
  end

  defp post(assigns) do
    ~H"""
    <article class="py-12 prose !prose-invert prose-neutral max-w-screen-md mx-auto px-8 sm:px-4 sm:prose-lg lg:px-0 lg:prose-xl prose-a:prose-link-2 prose-img:rounded">
      <%= render_post(@post) |> raw() %>
    </article>
    """
  end

  defp render_post(post) do
    NotionRenderer.block_to_html(post.raw_content["_children"], config: Renderer.Config.html())
  end
end
