defmodule Benvp.Notion.Schema.Emoji do
  @enforce_keys [
    :type,
    :emoji
  ]

  defstruct [
    :type,
    :emoji
  ]

  @type t :: %__MODULE__{
          type: :emoji,
          emoji: String.t()
        }
end
