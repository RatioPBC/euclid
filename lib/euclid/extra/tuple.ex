defmodule Euclid.Extra.Tuple do
  @moduledoc deprecated: "Use `Euclid.Tuple` instead"

  @deprecated "Use `Euclid.Tuple.error/1` instead"
  def error(thing), do: {:error, thing}

  @deprecated "Use `Euclid.Tuple.ok/1` instead"
  def ok(thing), do: {:ok, thing}
end
