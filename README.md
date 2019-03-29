# Transformable

Transform arbitrary maps and keyword lists into structs.

This is really a wrapper around `struct/2`, with some additional preprocessing
logic to handle things like default values and data structures with either
string or atom keys.

Transformable is defined as a Protocol with an Any implementation. You can
write your own implementation and use `transform/2` to specify custom outputs.

## Installation

Transformable is available on Hex. The package can be installed
by adding `transformable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:transformable, "~> 0.1.0"}
  ]
end
```

Find the docs at [https://hexdocs.pm/transformable](https://hexdocs.pm/transformable).

