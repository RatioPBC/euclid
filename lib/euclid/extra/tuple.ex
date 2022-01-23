defmodule Euclid.Extra.Tuple do
  @moduledoc "Deprecated. Use `Euclid.Sugar` instead."

  @deprecated "Use `Euclid.Sugar.error/1` instead"
  def error(thing), do: {:error, thing}

  @deprecated "Use `Euclid.Sugar.ok/1` instead"
  def ok(thing), do: {:ok, thing}
end
