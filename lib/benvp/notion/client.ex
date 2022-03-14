defmodule Benvp.Notion.Client do
  @moduledoc """
  Defines a behaviour that can be used to build a Notion API client.
  """

  alias Benvp.Notion.Schema

  @callback query_database(id :: String.t(), filter :: map()) ::
              {:ok, result :: map()} | {:error, reason :: Schema.Error.t() | term()}

  @type get_block_options :: [resursive: boolean()]

  @callback get_block(id :: String.t(), opts :: get_block_options()) ::
              {:ok, result :: map()} | {:error, reason :: Schema.Error.t() | term()}
end
