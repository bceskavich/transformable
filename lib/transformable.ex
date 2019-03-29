defprotocol Transformable do
  @moduledoc """
  Transform arbitrary maps and keyword lists into structs.

  This is really a wrapper around `struct/2`, with some additional preprocessing
  logic to handle things like default values and data structures with either
  string or atom keys.

  Transformable is defined as a Protocol with an Any implementation. You can
  write your own implementation and use `transform/2` to specify custom outputs.
  """

  @fallback_to_any true

  @doc """
  Takes a map or keyword list and a target, and transforms the former into the
  latter.

  The target can be either a struct, a module that exposes a struct, or a keyword
  list with options. Valid options are:

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

      # With options
      iex> Transformable.transform(%{id: 1}, as: Tester, default: false)
      %Tester{id: 1, name: false}

      # The data to transform can also have string keys
      iex> Transformable.transform(%{"id" => 1}, Tester)
      %Tester{id: 1, name: ""}

      # OR the data to transform can be a keyword list
      iex> Transformable.transform([id: 1], Tester)
      %Tester{id: 1, name: ""}
  """
  @spec transform(map | keyword, keyword | module | struct) :: any
  def transform(entity, opts)
end

defimpl Transformable, for: Any do
  def transform(data, %{__struct__: mod}), do: do_transform(data, mod)
  def transform(data, mod) when is_atom(mod), do: do_transform(data, mod)

  def transform(data, opts) when is_list(opts) do
    do_transform(data, Keyword.get(opts, :as), opts)
  end

  defp do_transform(data, mod, opts \\ []) do
    data = Map.new(data)

    mod
    |> struct()
    |> Map.from_struct()
    |> Map.new(fn {key, default} ->
      cond do
        Map.has_key?(data, key) ->
          {key, Map.get(data, key)}

        Map.has_key?(data, Atom.to_string(key)) ->
          {key, Map.get(data, Atom.to_string(key))}

        Keyword.has_key?(opts, :default) ->
          {key, Keyword.get(opts, :default)}

        true ->
          {key, default}
      end
    end)
    |> to_struct(mod)
  end

  defp to_struct(data, mod), do: struct(mod, data)
end
