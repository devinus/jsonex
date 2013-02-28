defmodule JSON do
  @moduledoc """
  ## Encoding

      JSON.encode [ok: true] #=> "{\"ok\":true}\"

  ## Decoding

      JSON.decode "{\"ok\":true}" #=> [{"ok",true}]
  """

  use JSON.Encoder
  use JSON.Decoder

  defmacro __using__(_) do
    quote do
      use JSON.Encoder
      use JSON.Decoder
    end
  end
end
