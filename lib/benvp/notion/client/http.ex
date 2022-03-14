defmodule Benvp.Notion.Client.HTTP do
  alias Benvp.Notion.Schema

  @behaviour Benvp.Notion.Client

  # Define the key where to store the chilrens when recursively
  # fetching them. Notion has it's own key "children" stated in the docs.
  # However, it isn't populated when using the api. To not conflict
  # with the API specs, we choose a different key for the children.
  @children_key "_children"
  @base_url "https://api.notion.com/v1"
  @notion_version "2021-08-16"

  @impl true
  def query_database(id, filter \\ nil) do
    case post(@base_url <> "/databases/#{id}/query", filter) do
      {:ok, %Finch.Response{status: 200} = res} ->
        results =
          res.body
          |> Jason.decode!()
          |> Map.get("results")

        {:ok, results}

      other_response ->
        handle_error(other_response)
    end
  end

  def get_page(id) do
    case get(@base_url <> "/pages/#{id}") do
      {:ok, %Finch.Response{status: 200} = res} ->
        {:ok, Jason.decode!(res.body)}

      other_response ->
        handle_error(other_response)
    end
  end

  @impl true
  def get_block(id, opts \\ []) do
    recursive = opts[:recursive]

    case get(@base_url <> "/blocks/#{id}") do
      {:ok, %Finch.Response{status: 200} = res} ->
        block = Jason.decode!(res.body)

        if recursive do
          {:ok, get_all_block_children(block)}
        else
          {:ok, block}
        end

      other_response ->
        handle_error(other_response)
    end
  end

  def get_block_children(id, opts \\ []) do
    case get(@base_url <> "/blocks/#{id}/children") do
      {:ok, %Finch.Response{status: 200} = res} ->
        blocks =
          res.body
          |> Jason.decode!()
          |> Map.get("results")

        {:ok, blocks}

      other_response ->
        handle_error(other_response)
    end
  end

  def get_all_block_children(id) when is_binary(id) do
    with {:ok, children} <- get_block_children(id) do
      get_all_block_children(children)
    end
  end

  def get_all_block_children(blocks) when is_list(blocks),
    do: Enum.map(blocks, &get_all_block_children/1)

  def get_all_block_children(block) do
    if block["has_children"] do
      with {:ok, children} <- get_block_children(block["id"]) do
        Map.put(block, @children_key, Enum.map(children, &get_all_block_children/1))
      end
    else
      block
    end
  end

  defp get(url, headers \\ []) do
    Finch.build(:get, url, default_headers() ++ headers)
    |> Finch.request(Benvp.Finch)
  end

  defp post(url, body, headers \\ []) do
    Finch.build(:post, url, default_headers() ++ headers, body && Jason.encode!(body))
    |> Finch.request(Benvp.Finch)
  end

  defp get_token() do
    Application.get_env(:benvp, :notion_access_token)
  end

  defp default_headers do
    [
      {"Authorization", "Bearer #{get_token()}"},
      {"Notion-Version", @notion_version},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]
  end

  defp handle_error(response) do
    case response do
      {:ok, %Finch.Response{} = res} ->
        error =
          res.body
          |> Jason.decode!()
          |> Schema.Error.new()

        {:error, error}

      {:error, _reason} = error ->
        error
    end
  end
end
