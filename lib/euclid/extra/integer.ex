defmodule Euclid.Extra.Integer do
  @moduledoc deprecated: "Use `Euclid.Integer` instead"

  @deprecated "Use `Euclid.Integer.rand/1` instead"
  def rand(max \\ 1_000_000_000),
    do: 0..max |> Enum.random()
end
