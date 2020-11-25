defmodule Euclid.Extra.ListTest do
  use Euclid.SimpleCase, async: true

  alias Euclid.Extra

  describe "compact" do
    test "with an empty list", do: [] |> Extra.List.compact() |> assert_eq([])
    test "with a list without nils", do: [:a, :b] |> Extra.List.compact() |> assert_eq([:a, :b])
    test "with a list with nil entries", do: [nil, :a, nil, :b, nil] |> Extra.List.compact() |> assert_eq([:a, :b])
  end

  describe "first" do
    test "gets the first item", do: ["a", "b"] |> Extra.List.first("c") |> assert_eq("a")
    test "falls back to default when list is empty", do: [] |> Extra.List.first("c") |> assert_eq("c")
    test "falls back to default when list is nil", do: nil |> Extra.List.first("c") |> assert_eq("c")
    test "when no default is provided", do: [] |> Extra.List.first() |> assert_eq(nil)
  end

  describe "only!" do
    test "returns the only item in the list" do
      assert Extra.List.only!([1]) == 1
    end

    test "blows up if there's not exactly one item in the list" do
      assert_raise RuntimeError, "Expected list to have exactly one item, but was: nil", fn -> Extra.List.only!(nil) end
      assert_raise RuntimeError, "Expected list to have exactly one item, but was: []", fn -> Extra.List.only!([]) end
      assert_raise RuntimeError, "Expected list to have exactly one item, but was: [1, 2]", fn -> Extra.List.only!([1, 2]) end
    end
  end

  describe "sorted?" do
    test "when the list is sorted" do
      assert Extra.List.sorted?([2, 5, 9])
      assert Extra.List.sorted?(["grape", "pumpkin", "zebra"])
    end

    test "when the list is not sorted" do
      refute Extra.List.sorted?([5, 1, 9])
      refute Extra.List.sorted?(["pumpkin", "grape", "zebra"])
    end
  end
end
