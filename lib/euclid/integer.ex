defmodule Euclid.Integer do
  @moduledoc "Deprecated. Use `Euclid.Random` instead."

  @deprecated "Use `Euclid.Random.integer/1` instead."
  def rand(max \\ 1_000_000_000),
    do: 0..max |> Enum.random()
end
