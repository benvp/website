defmodule Benvp.Blog.Cache do
  @moduledoc """
  A cache for blog posts.

  The cache behaviour is "stale-while-revalidate". This means, that the
  cache will return a stale value when the ttl expires and revalidates
  the value in the background. Subsequent requests will receive the updated
  value afterwards.
  """
  use GenServer

  require Logger

  @table :blog_posts
  @ttl :timer.hours(1)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    table = :ets.new(@table, [:named_table, read_concurrency: true])
    {:ok, table}
  end

  def get(key, default_fun, opts \\ []) do
    ttl = Keyword.get(opts, :ttl, @ttl)

    case get_value(key) do
      nil ->
        set(key, default_fun.(), ttl: ttl)

      {value, expires_at} ->
        if DateTime.compare(DateTime.utc_now(), expires_at) == :lt do
          value
        else
          # set value asynchronously and immediately
          # return the cached value. This achieves the
          # "stale-while-revalidate" behaviour.
          Task.async(fn ->
            set(key, default_fun.(), ttl: ttl)
          end)

          value
        end
    end
  end

  def set(key, value, opts \\ []) do
    ttl = Keyword.get(opts, :ttl, @ttl)
    expires_at = calc_expiration(ttl)

    GenServer.call(__MODULE__, {:set, {key, {value, expires_at}}})
    |> elem(0)
  end

  defp get_value(key) do
    :ets.lookup_element(@table, key, 2)
  rescue
    _ -> nil
  end

  # Server

  @impl true
  def handle_call({:set, {key, value}}, _from, state) do
    true = :ets.insert(@table, {key, value})
    {:reply, value, state}
  end

  defp calc_expiration(ttl) do
    DateTime.utc_now()
    |> DateTime.add(ttl, :millisecond)
  end
end
