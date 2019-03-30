defprotocol Transformable do
  @moduledoc """
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
  """

  @doc """
  Takes a Map or Keyword List and a target, and transforms the former into the latter.

  The target can be a struct or a module that exposes a struct. The target can
  also be a set of options to configure the transformation logic. Valid options
  are:

  - `as` - The transform target (struct or module)
  - `default` - Overrides the default value defined in the target struct with the
  value provided

  ## Examples

      # Our target
      defmodule Tester do
        defstruct [:id, name: ""]
      end

      # The target is just a module alias
      iex> Transformable.transform(%{id: 1}, Tester)
      %Tester{id: 1, name: ""}

      # The target is a struct
      iex> Transformable.transform(%{id: 1}, %Tester{})
      %Tester{id: 1, name: ""}

      # With options, here we are overriding the struct defaults
      iex> Transformable.transform(%{id: 1}, as: Tester, default: false)
      %Tester{id: 1, name: false}

      # The data to transform can also have string keys
      iex> Transformable.transform(%{"id" => 1}, Tester)
      %Tester{id: 1, name: ""}

      # OR the data to transform can be a keyword list
      iex> Transformable.transform([id: 1], Tester)
      %Tester{id: 1, name: ""}
  """
  @spec transform(map() | keyword(), keyword() | module() | struct()) :: struct()
  def transform(entity, opts)
end

defimpl Transformable, for: Map do
  alias Transformable.Utils

  def transform(map, opts), do: Utils.transform(map, opts)
end

defimpl Transformable, for: List do
  alias Transformable.Utils

  def transform(kwl, opts) do
    kwl
    |> Map.new()
    |> Utils.transform(opts)
  end
end
