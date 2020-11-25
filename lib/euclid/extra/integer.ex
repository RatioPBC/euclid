defmodule Euclid.Extra.Integer do
  def rand(max \\ 1_000_000_000),
    do: 0..max |> Enum.random()
end
