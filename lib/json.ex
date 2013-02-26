defmodule JSON do
  use JSON.Encoder
  use JSON.Decoder

  defmacro __using__(_) do
    quote do
      use JSON.Encoder
      use JSON.Decoder
    end
  end
end
