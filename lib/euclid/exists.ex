defmodule Euclid.Exists do
  @moduledoc "Functions related to terms being blank or not"

  def any?(enum) when is_list(enum) or is_map(enum), do: enum |> Enum.any?(&present?/1)

  def blank?(nil), do: true
  def blank?(s) when is_binary(s), do: s |> String.trim() |> String.length() == 0
  def blank?([]), do: true
  def blank?(list) when is_list(list), do: false
  def blank?(m) when is_map(m), do: map_size(m) == 0
  def blank?(true), do: false
  def blank?(false), do: true
  def blank?(_), do: false

  def present?(value), do: !blank?(value)
  def first_present(values) when is_list(values), do: values |> Enum.find(&present?/1)
  def presence(value), do: if(present?(value), do: value, else: nil)

  def or_default(value, default), do: if(present?(value), do: value, else: default)

  def filter(values), do: Enum.filter(values, &present?/1)
  def join(values, separator \\ " ") when is_list(values), do: values |> filter() |> Enum.join(separator)
end
