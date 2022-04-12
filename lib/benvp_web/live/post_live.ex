defmodule BenvpWeb.PostLive do
  use BenvpWeb, :live_view

  alias Benvp.Blog
  alias Benvp.Notion.Renderer
  alias BenvpWeb.SeoMeta
  alias LiveMotion

  def mount(%{"slug" => slug}, _session, socket) do
    post = Blog.get_post_by_slug!(slug)

    meta_attrs =
      SeoMeta.seo_meta_attrs(%SeoMeta{
        title: SeoMeta.page_title(post.title),
        description: post.abstract,
        image_url: Routes.static_url(socket, "/images/meta-logo.png"),
        url: Routes.live_path(socket, __MODULE__, post.slug)
      })

    {:ok,
     socket
     |> assign(:post, post)
     |> assign(:page_title, SeoMeta.page_title(post.title))
     |> assign(:meta_attrs, meta_attrs)}
  end

  def render(assigns) do
    ~H"""
    <LiveMotion.motion
      id="post-content"
      initial={[y: 20, opacity: 0]}
      animate={[y: 0, opacity: 1]}
      exit={[y: 20, opacity: 0]}
    >
      <.post post={@post} />
    </LiveMotion.motion>
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
