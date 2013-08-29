defmodule JSON.Encoder do
  use Behaviour

  alias :jsx, as: JSX

  defcallback encode(terms :: JSX.json_term) :: JSX.json_text
  defcallback encode(terms :: JSX.json_term, opts :: list) :: JSX.json_text
  defcallback pre_encoder(value :: any) :: JSX.json_text

  defmacro __using__(_) do
    quote do
      @behaviour JSON.Encoder

      @date_format "~4.10.0B-~2.10.0B-~2.10.0B"
      @datetime_format "~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0BZ"

      defexception EncodeError, message: "cannot encode"

      def encode(terms, opts // []) do
        opts = Keyword.merge([pre_encode: &pre_encoder/1], opts)
        try do
          :jsx.encode(terms, opts)
        rescue
          ArgumentError -> raise alias!(EncodeError)
        end
      end

      def pre_encoder(nil), do: :null

      def pre_encoder(value) when is_atom(value) and not value in [:null, true, false] do
        atom_to_binary(value)
      end

      def pre_encoder({ year, month, day })
          when is_integer(year) and is_integer(month) and is_integer(day) do
        :io_lib.format(@date_format, [ year, month, day ]) |> iolist_to_binary
      end

      def pre_encoder({ { year, month, day }, { hour, minute, second } })
          when is_integer(year) and is_integer(month) and is_integer(day)
           and is_integer(hour) and is_integer(minute) and is_integer(second) do
        :io_lib.format(@datetime_format, [ year, month, day, hour, minute, second ])
          |> iolist_to_binary
      end

      def pre_encoder(value), do: value

      defoverridable [encode: 1, encode: 2, pre_encoder: 1]
    end
  end
end
