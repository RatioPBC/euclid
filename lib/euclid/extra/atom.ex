defmodule Euclid.Extra.Atom do
  @moduledoc deprecated: "Use `Euclid.Atom` instead"

  @deprecated "Use `Euclid.Atom.from_string/1` instead"
  def from_string(nil), do: raise(ArgumentError, message: "Unable to convert nil into an atom")
  def from_string(s) when is_binary(s), do: String.to_atom(s)
  def from_string(a) when is_atom(a), do: a

  @deprecated "Use `Euclid.Atom.to_string/1` instead"
  def to_string(nil), do: raise(ArgumentError, message: "Unable to convert nil into a string")
  def to_string(a) when is_atom(a), do: Atom.to_string(a)
  def to_string(s) when is_binary(s), do: s
end
