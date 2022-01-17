defmodule Euclid.List do
  @moduledoc "List-related functions"

  def compact(list) when is_list(list), do: list |> Euclid.Enum.compact()

  def first(list, default \\ nil)
  def first(nil, default), do: default
  def first(list, default) when is_list(list), do: List.first(list) || default

  @doc "returns the only item in the list; raises if there are no items or more than 1 item"
  def only!([item]), do: item
  def only!(list), do: raise("Expected list to have exactly one item, but was: #{inspect(list)}")

  def sorted?(list) when is_list(list), do: Enum.sort(list) == list
end
