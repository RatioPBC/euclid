defmodule Euclid.Extra.Map do
  alias Euclid.Exists
  alias Euclid.Extra

  def all_values_blank?(map) do
    map |> Map.values() |> Enum.all?(&Exists.blank?/1)
  end

  def atomize_keys(map) do
    map |> Map.new(fn {k, v} -> {Extra.Atom.from_string(k), v} end)
  end

  def deep_atomize_keys(map) when is_map(map) do
    Map.new(map, fn
      {k, v} when is_map(v) -> {Extra.Atom.from_string(k), deep_atomize_keys(v)}
      {k, list} when is_list(list) -> {Extra.Atom.from_string(k), Enum.map(list, fn v -> deep_atomize_keys(v) end)}
      {k, v} -> {Extra.Atom.from_string(k), v}
    end)
  end

  def deep_atomize_keys(not_a_map), do: not_a_map

  def merge(a, b) when is_map(a) and is_map(b), do: Map.merge(a, b)
  def merge(a, b), do: Map.merge(Enum.into(a, %{}), Enum.into(b, %{}))

  def rename_key(map, old_key_name, new_key_name) when is_map_key(map, old_key_name) do
    {value, new_map} = Map.pop(map, old_key_name)
    Map.put(new_map, new_key_name, value)
  end

  def rename_key(map, _, _), do: map

  def rename_key(map, {old_key, new_key}) do
    rename_key(map, old_key, new_key)
  end

  def rename_keys(map, keys_map) do
    Enum.reduce(keys_map, map, &rename_key(&2, &1))
  end

  def stringify_keys(map) do
    map |> Map.new(fn {k, v} -> {Extra.Atom.to_string(k), v} end)
  end

  def transform(map, key, transformer) when is_binary(key) and is_map_key(map, key) do
    Map.update!(map, key, transformer)
  end

  def transform(map, keys, transformer) when is_list(keys) do
    Enum.reduce(keys, map, fn key, new_map -> transform(new_map, key, transformer) end)
  end

  def transform(map, _, _), do: map
end
