# JSON for Elixir

[![Build Status](https://travis-ci.org/devinus/jsonex.png)](https://travis-ci.org/devinus/jsonex)

## Encoding

```elixir
JSON.encode [ok: true] #=> "{\"ok\":true}"
```

## Decoding

```elixir
JSON.decode "{\"ok\":true}" #=> [{"ok",true}]
```

## Custom encoder/decoders

```elixir
defmodule MyJSON do
  use JSON

  def pre_encoder(:undefined), do: :null
  def pre_encoder(value), 	   do: super(value)

  def post_decoder(null),  do: :undefined
  def post_decoder(value), do: super(value)
end
```
