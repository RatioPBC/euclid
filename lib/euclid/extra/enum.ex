defmodule Euclid.Extra.Enum do
  @moduledoc deprecated: "Use `Euclid.Enum` instead"

  @deprecated "Use `Euclid.Enum.at/2` instead"
  def at!(enum, index) do
    if length(enum) < index + 1 do
      raise "Out of range: index #{index} of enum with length #{length(enum)}: #{inspect(enum)}"
    else
      Enum.at(enum, index)
    end
  end

  @deprecated "Use `Euclid.Enum.compact/1` instead"
  def compact(enum),
    do: enum |> Enum.reject(&is_nil(&1))

  @deprecated "Use `Euclid.Enum.fetch_multiple/2` instead"
  def fetch_multiple(enum, indices) do
    for index <- indices do
      Enum.fetch!(enum, index)
    end
  end

  @deprecated "Use `Euclid.Enum.find_indices/2` instead"
  def find_indices(enum, values) do
    for value <- values do
      Enum.find_index(enum, &(value == &1))
    end
  end

  @deprecated "Use `Euclid.Enum.first!/1` instead"
  def first!(enum),
    do: Enum.at(enum, 0) || raise("Expected enumerable to have at least one item")

  @deprecated "Use `Euclid.Enum.isort/1` instead"
  def isort(enum),
    do: enum |> isort_by(&to_string/1)

  @deprecated "Use `Euclid.Enum.isort_by/2` instead"
  def isort_by(enum, mapper),
    do: enum |> Enum.sort_by(&(mapper.(&1) |> String.downcase()))

  @deprecated "Use `Euclid.Enum.pluck/2` instead"
  def pluck(enumerable, properties) when is_list(properties),
    do: Enum.map(enumerable, &Map.take(&1, properties))

  def pluck(enumerable, property),
    do: Enum.map(enumerable, &Map.get(&1, property))

  @deprecated "Use `Euclid.Enum.tids/1` instead"
  def tids(enumerable),
    do: enumerable |> Enum.map(& &1.tid)

  @deprecated "Use `Euclid.Enum.update_or_append_by/3` instead"
  def update_or_append_by([] = enumerable, _filter, mergeable) do
    enumerable ++ [mergeable]
  end

  def update_or_append_by([%{} | _] = enumerable, filter, mergeable) do
    enumerable
    |> get_and_update_in(
      [Access.filter(filter)],
      fn prev -> {prev, Map.merge(prev, mergeable)} end
    )
    |> case do
      {[], list} -> list ++ [mergeable]
      {_updated_obj, updated_list} -> updated_list
    end
  end
end
