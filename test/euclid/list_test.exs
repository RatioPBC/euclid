defmodule Euclid.ListTest do
  use Euclid.SimpleCase, async: true

  describe "compact" do
    test "with an empty list", do: [] |> Euclid.List.compact() |> assert_eq([])
    test "with a list without nils", do: [:a, :b] |> Euclid.List.compact() |> assert_eq([:a, :b])
    test "with a list with nil entries", do: [nil, :a, nil, :b, nil] |> Euclid.List.compact() |> assert_eq([:a, :b])
  end

  describe "first" do
    test "gets the first item", do: ["a", "b"] |> Euclid.List.first("c") |> assert_eq("a")
    test "falls back to default when list is empty", do: [] |> Euclid.List.first("c") |> assert_eq("c")
    test "falls back to default when list is nil", do: nil |> Euclid.List.first("c") |> assert_eq("c")
    test "when no default is provided", do: [] |> Euclid.List.first() |> assert_eq(nil)
  end

  describe "only!" do
    test "returns the only item in the list" do
      assert Euclid.List.only!([1]) == 1
    end

    test "blows up if there's not exactly one item in the list" do
      assert_raise RuntimeError, "Expected list to have exactly one item, but was: nil", fn -> Euclid.List.only!(nil) end
      assert_raise RuntimeError, "Expected list to have exactly one item, but was: []", fn -> Euclid.List.only!([]) end
      assert_raise RuntimeError, "Expected list to have exactly one item, but was: [1, 2]", fn -> Euclid.List.only!([1, 2]) end
    end
  end

  describe "sorted?" do
    test "when the list is sorted" do
      assert Euclid.List.sorted?([2, 5, 9])
      assert Euclid.List.sorted?(["grape", "pumpkin", "zebra"])
    end

    test "when the list is not sorted" do
      refute Euclid.List.sorted?([5, 1, 9])
      refute Euclid.List.sorted?(["pumpkin", "grape", "zebra"])
    end
  end
end
