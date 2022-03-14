defmodule Benvp.Notion.Renderer.Config do
  def html do
    config = NotionRenderer.Config.html()
    put_in(config.renderers["code"], &code/3)
  end

  def code(block, {next, _self, _child}, opts) do
    language = opts[:full_block]["code"]["language"]
    class = "language-#{language}"
    content = next.(block) |> String.replace("<br />", "\n")

    "<pre class=\"#{class}\" phx-hook=\"Prism\" phx-update=\"ignore\" id=\"1\"><code>#{content}</code></pre>"
  end
end
