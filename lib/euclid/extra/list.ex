defmodule Euclid.Extra.List do
  @moduledoc deprecated: "Use `Euclid.List` instead"

  @deprecated "Use `Euclid.List.compact/1` instead"
  def compact(list) when is_list(list), do: list |> Euclid.Enum.compact()

  @deprecated "Use `Euclid.List.first/2` instead"
  def first(list, default \\ nil)
  def first(nil, default), do: default
  def first(list, default) when is_list(list), do: List.first(list) || default

  @deprecated "Use `Euclid.List.only!/1` instead"
  @doc "returns the only item in the list; raises if there are no items or more than 1 item"
  def only!([item]), do: item
  def only!(list), do: raise("Expected list to have exactly one item, but was: #{inspect(list)}")

  @deprecated "Use `Euclid.List.sorted?/1` instead"
  def sorted?(list) when is_list(list), do: Enum.sort(list) == list
end
