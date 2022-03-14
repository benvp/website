defmodule Benvp.Notion.Schema.Error do
  defexception [:code, :message]

  @type t :: %__MODULE__{
          code: String.t(),
          message: String.t()
        }

  def new(map) do
    %__MODULE__{
      code: map["code"],
      message: map["message"]
    }
  end
end
