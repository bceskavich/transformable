# Transformable

Transform arbitrary maps and keyword lists into structs.

Transformable is a wrapper around `struct/2`. Out of the box, it supports
easily converting Maps and Keyword Lists into structs. Like with `struct/2`,
only the keys in the struct will be pulled out of your initial data structure.
Maps passed in can have either string or atom keys, but Transformable doesn't
use the (unsafe) `String.to_atom/1`. Default values on the struct will be
respected, or can be overriden.

Transformable is defined as a Protocol with implementations for Map and List.
You can write your own implementation and use `transform/2` to specify custom
outputs.

## Installation

Transformable is [available on Hex](https://hex.pm/packages/transformable). The package can be installed
by adding `transformable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:transformable, "~> 0.2.0"}
  ]
end
```

## Docs

Find the docs [on HexDocs](https://hexdocs.pm/transformable/0.2.0/Transformable.html#content).

