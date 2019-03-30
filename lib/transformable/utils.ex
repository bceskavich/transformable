defmodule Transformable.Utils do
  def transform(data, %{__struct__: mod}), do: do_transform(data, mod)
  def transform(data, mod) when is_atom(mod), do: do_transform(data, mod)

  def transform(data, opts) when is_list(opts) do
    do_transform(data, Keyword.get(opts, :as), opts)
  end

  defp do_transform(data, mod, opts \\ []) do
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
