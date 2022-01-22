defmodule Euclid.Exists do
  @moduledoc deprecated: "Use `Euclid.Term`, `Euclid.List`, and `Euclid.Enum` instead"

  @deprecated "Use `Euclid.Enum.any_present?/1` instead"
  def any?(enum) when is_list(enum) or is_map(enum), do: enum |> Enum.any?(&present?/1)

  @deprecated "Use `Euclid.Term.blank?/1` instead"
  def blank?(nil), do: true
  def blank?(s) when is_binary(s), do: s |> String.trim() |> String.length() == 0
  def blank?([]), do: true
  def blank?(list) when is_list(list), do: false
  def blank?(m) when is_map(m), do: map_size(m) == 0
  def blank?(true), do: false
  def blank?(false), do: true
  def blank?(_), do: false

  @deprecated "Use `Euclid.Term.present?/1` instead"
  def present?(value), do: !blank?(value)

  @deprecated "Use `Euclid.List.first_present/1` instead"
  def first_present(values) when is_list(values), do: values |> Enum.find(&present?/1)

  @deprecated "Use `Euclid.Term.presence/1` instead"
  def presence(value), do: if(present?(value), do: value, else: nil)

  @deprecated "Use `Euclid.Term.or_default/2` instead"
  def or_default(value, default), do: if(present?(value), do: value, else: default)

  @deprecated "Use `Euclid.Enum.filter_present/1` instead"
  def filter(values), do: Enum.filter(values, &present?/1)

  @deprecated "Use `Euclid.Enum.join_present/2` instead"
  def join(values, separator \\ " ") when is_list(values), do: values |> filter() |> Enum.join(separator)
end
