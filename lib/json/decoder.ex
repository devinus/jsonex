defmodule JSON.Decoder do
  use Behaviour

  alias :jsx, as: JSX

  defcallback decode(string :: JSX.json_text) :: JSX.json_term
  defcallback decode(string :: JSX.json_text, opts :: list) :: JSX.json_term
  defcallback post_decoder(value :: JSX.json_term) :: any

  defmacro binary(size) do
    quote do: [binary, size(unquote(size))]
  end

  defmacro __using__(_) do
    quote do
      @behaviour JSON.Decoder

      import JSON.Decoder

      defexception DecodeError, message: "cannot decode"

      def decode(string, opts // []) do
        opts = Keyword.merge([post_decode: function(post_decoder/1)], opts)
        try do
          case :jsx.decode(string, opts) do
            { :incomplete, _ } -> raise alias!(DecodeError)
            other -> other
          end
        rescue
          ArgumentError -> raise alias!(DecodeError)
        end
      end

      def post_decoder(:null), do: nil

      def post_decoder(<<yyyy :: binary(4), ?-, mm :: binary(2), ?-, dd :: binary(2)>> = string) do
        if string =~ %r/^\d{4}-\d{2}-\d{2}$/ do
          list_to_tuple(lc p inlist [ yyyy, mm, dd ], do: binary_to_integer(p))
        else
          string
        end
      end

      def post_decoder(<<yyyy :: binary(4), ?-, mm :: binary(2), ?-, dd :: binary(2), ?T,
                           hh :: binary(2), ?:, nn :: binary(2), ?:, ss :: binary(2), ?Z>> = string) do
        if string =~ %r/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/ do
          [ year, month, day, hour, minute, second ]
            = lc p inlist [ yyyy, mm, dd, hh, nn, ss ], do: binary_to_integer(p)
          { { year, month, day }, { hour, minute, second } }
        else
          string
        end
      end

      def post_decoder(value), do: value

      defoverridable [decode: 1, decode: 2, post_decoder: 1]
    end
  end
end
