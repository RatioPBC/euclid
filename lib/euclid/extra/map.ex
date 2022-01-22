defmodule Euclid.Extra.Map do
  @moduledoc deprecated: "Use `Euclid.Map` instead"

  @deprecated "Use `Euclid.Map.all_values_blank?/1` instead"
  def all_values_blank?(map) do
    map |> Map.values() |> Enum.all?(&Euclid.Term.blank?/1)
  end

  @deprecated "Use `Euclid.Map.atomize_keys/1` instead"
  def atomize_keys(map) do
    map |> Map.new(fn {k, v} -> {Euclid.Atom.from_string(k), v} end)
  end

  @deprecated "Use `Euclid.Map.deep_atomize_keys/1` instead"
  def deep_atomize_keys(list) when is_list(list) do
    list
    |> Enum.map(&deep_atomize_keys(&1))
  end

  def deep_atomize_keys(map) when is_map(map) do
    Map.new(map, fn
      {k, v} when is_map(v) -> {Euclid.Atom.from_string(k), deep_atomize_keys(v)}
      {k, list} when is_list(list) -> {Euclid.Atom.from_string(k), Enum.map(list, fn v -> deep_atomize_keys(v) end)}
      {k, v} -> {Euclid.Atom.from_string(k), v}
    end)
  end

  def deep_atomize_keys(not_a_map), do: not_a_map

  @deprecated "Use `Euclid.Map.merge/2` instead"
  def merge(a, b) when is_map(a) and is_map(b), do: Map.merge(a, b)
  def merge(a, b), do: Map.merge(Enum.into(a, %{}), Enum.into(b, %{}))

  @deprecated "Use `Euclid.Map.rename_key/3` instead"
  def rename_key(map, old_key_name, new_key_name) when is_map_key(map, old_key_name) do
    {value, new_map} = Map.pop(map, old_key_name)
    Map.put(new_map, new_key_name, value)
  end

  def rename_key(map, _, _), do: map

  @deprecated "Use `Euclid.Map.rename_key/2` instead"
  def rename_key(map, {old_key, new_key}) do
    rename_key(map, old_key, new_key)
  end

  @deprecated "Use `Euclid.Map.rename_keys/2` instead"
  def rename_keys(map, keys_map) do
    Enum.reduce(keys_map, map, &rename_key(&2, &1))
  end

  @deprecated "Use `Euclid.Map.stringify_keys/1` instead"
  def stringify_keys(map) do
    map |> Map.new(fn {k, v} -> {Euclid.Atom.to_string(k), v} end)
  end

  @deprecated "Use `Euclid.Map.transform/3` instead"
  def transform(map, key, transformer) when is_binary(key) and is_map_key(map, key) do
    Map.update!(map, key, transformer)
  end

  def transform(map, keys, transformer) when is_list(keys) do
    Enum.reduce(keys, map, fn key, new_map -> transform(new_map, key, transformer) end)
  end

  def transform(map, _, _), do: map
end
