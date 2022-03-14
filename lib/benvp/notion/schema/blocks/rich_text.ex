defmodule Benvp.Notion.Schema.Blocks.RichText do
  @enforce_keys [
    :plain_text,
    :href,
    :annotations,
    :type
  ]

  defstruct [
    :plain_text,
    :href,
    :annotations,
    :type
  ]

  @type t :: %__MODULE__{
          plain_text: String.t(),
          href: String.t(),
          annotations: %{
            bold: boolean(),
            italic: boolean(),
            strikethrough: boolean(),
            underline: boolean(),
            code: boolean(),
            color: String.t()
          },
          type: :text | :mention | :equation
        }
end
