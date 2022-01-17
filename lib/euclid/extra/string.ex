defmodule Euclid.Extra.String do
  @moduledoc deprecated: "Use `Euclid.String` instead"

  use Bitwise

  alias Euclid.Exists

  @deprecated "Use `Euclid.String.dasherize/1` instead"
  def dasherize(atom) when is_atom(atom), do: atom |> Atom.to_string() |> dasherize()

  def dasherize(string) when is_binary(string),
    do:
      string
      |> Macro.underscore()
      |> String.replace(~r{[^a-z0-9]+}i, "-")
      |> String.trim_leading("-")
      |> String.trim_trailing("-")

  @deprecated "Use `Euclid.String.inner_truncate/2` instead"
  def inner_truncate(nil, _), do: nil

  def inner_truncate(s, max_length) do
    case String.length(s) <= max_length do
      true ->
        s

      false ->
        left_length = (max_length / 2) |> Float.ceil() |> round()
        right_length = (max_length / 2) |> Float.floor() |> round()
        "#{String.slice(s, 0, left_length)}…#{String.slice(s, -right_length, right_length)}"
    end
  end

  @deprecated "Use `Euclid.String.squish/1` instead"
  def squish(nil), do: nil
  def squish(s), do: s |> trim() |> Elixir.String.replace(~r/\s+/, " ")

  @deprecated "Use `Euclid.String.surround/2` instead"
  def surround(s, surrounder), do: surrounder <> s <> surrounder

  @deprecated "Use `Euclid.String.surround/3` instead"
  def surround(s, prefix, suffix), do: prefix <> s <> suffix

  @deprecated "Use `Euclid.String.to_integer/1` instead"
  def to_integer(nil), do: nil
  def to_integer(""), do: nil

  def to_integer(s) when is_binary(s),
    do: s |> trim() |> Elixir.String.replace(",", "") |> Elixir.String.to_integer()

  @deprecated "Use `Euclid.String.to_integer/2` instead"
  def to_integer(s, :lenient) when is_binary(s),
    do: s |> String.replace(~r|\D|, "") |> Elixir.String.to_integer()

  def to_integer(s, default: default), do: s |> to_integer() |> Exists.or_default(default)

  @deprecated "Use `Euclid.String.trim/1` instead"
  def trim(nil), do: nil
  def trim(s) when is_binary(s), do: Elixir.String.trim(s)

  @deprecated "Use `Euclid.String.truncate_at/3` instead"
  def truncate_at(s, at, limit) do
    s
    |> String.graphemes()
    |> Enum.take(limit)
    |> Enum.reverse()
    |> Enum.split_while(fn c -> c != at end)
    |> case do
      {a, []} -> a
      {[], b} -> b
      {_a, b} -> b
    end
    |> Enum.reverse()
    |> Enum.join("")
  end

  @deprecated "Use `Euclid.String.underscore/1` instead"
  def underscore(atom) when is_atom(atom), do: atom |> Atom.to_string() |> underscore()

  def underscore(string) when is_binary(string),
    do:
      string
      |> Macro.underscore()
      |> String.replace(~r{[^a-z0-9]+}i, "_")
      |> String.trim_leading("_")
      |> String.trim_trailing("_")

  @doc """
  Compares the two binaries in constant-time to avoid timing attacks.
  See: http://codahale.com/a-lesson-in-timing-attacks/
  """
  @deprecated "Use `Euclid.String.secure_compare/2` instead"
  def secure_compare(left, right) when is_nil(left) or is_nil(right), do: false

  @spec secure_compare(binary(), binary()) :: boolean()
  def secure_compare(left, right) when is_binary(left) and is_binary(right) do
    byte_size(left) == byte_size(right) and secure_compare(left, right, 0)
  end

  defp secure_compare(<<x, left::binary>>, <<y, right::binary>>, acc) do
    xorred = Bitwise.bxor(x, y)
    secure_compare(left, right, acc ||| xorred)
  end

  defp secure_compare(<<>>, <<>>, acc) do
    acc === 0
  end
end
