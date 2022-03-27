defmodule Benvp.Notion do
  def client do
    Application.fetch_env!(:benvp, :notion_client)
  end

  @doc """
  Saves blog media to the notion_media_dir.

  Returns a tuple of {file_path, public_url}
  """
  @spec save_media!(String.t(), String.t()) :: {String.t(), String.t()}
  def save_media!(url, filename) do
    {:ok, %Finch.Response{status: 200} = res} =
      Finch.build(:get, url)
      |> Finch.request(Benvp.Finch)

    [ext | _] =
      List.keyfind(res.headers, "content-type", 0)
      |> elem(1)
      |> MIME.extensions()

    dest =
      Path.join([
        Application.fetch_env!(:benvp, :notion_media_dir),
        "#{filename}.#{ext}"
      ])

    File.mkdir_p!(Path.dirname(dest))
    File.write!(dest, res.body)

    public_url = "/media/#{filename}.#{ext}"

    {dest, public_url}
  end
end
