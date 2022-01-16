defmodule Euclid.IntegerTest do
  use Euclid.SimpleCase, async: true

  test "rand" do
    0..10_000
    |> Enum.map(fn _ -> Euclid.Integer.rand(10) end)
    |> Enum.uniq()
    |> Enum.sort()
    |> assert_eq([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  end
end
