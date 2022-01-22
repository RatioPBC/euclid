defmodule Euclid.EnumTest do
  use Euclid.SimpleCase, async: true

  describe "any_present?" do
    test "is true if any items are present" do
      assert Euclid.Enum.any_present?([nil, "", " ", 43])
    end

    test "is false if no items are present" do
      refute Euclid.Enum.any_present?([nil, "", " ", false])
    end
  end

  describe "fetch_multiple" do
    test "fetches from multiple indices" do
      ~w{zero one two three four five}
      |> Euclid.Enum.fetch_multiple([1, 3, 5])
      |> assert_eq(~w{one three five})
    end
  end

  describe "filter_present" do
    test "filters in present values" do
      assert Euclid.Enum.filter_present([nil, "not nil", [], %{}]) == ["not nil"]
    end
  end

  describe "find_indices" do
    test "finds indices that equal the given values" do
      ~w{zero one two three four five}
      |> Euclid.Enum.find_indices(~w{one three five})
      |> assert_eq([1, 3, 5])
    end
  end

  describe "first!" do
    test "returns the first item in the enum" do
      assert Euclid.Enum.first!(["foo"]) == "foo"
      assert Euclid.Enum.first!(["foo", "bar"]) == "foo"
    end

    test "blows up if the enum is empty" do
      assert_raise RuntimeError, "Expected enumerable to have at least one item", fn -> Euclid.Enum.first!([]) end
    end
  end

  describe "isort" do
    test "sorts strings case-insensitively" do
      assert Euclid.Enum.isort(["Banana", "apple", "cherry"]) == ["apple", "Banana", "cherry"]
    end

    test "sorts non-strings by their string equivalents" do
      assert Euclid.Enum.isort([48, "Pudding", "apple", :gorilla]) == [48, "apple", :gorilla, "Pudding"]
    end
  end

  describe "isort_by" do
    test "sorts by the mapper case-insensitively" do
      Euclid.Enum.isort_by([%{name: "Banana"}, %{name: "apple"}, %{name: "cherry"}], & &1.name)
      |> assert_eq([%{name: "apple"}, %{name: "Banana"}, %{name: "cherry"}])
    end
  end

  describe "join" do
    test "joins present items" do
      assert Euclid.Enum.join_present(["ant", "", "bat", nil, "cow"]) == "ant bat cow"
      assert Euclid.Enum.join_present(["ant", "", "bat", nil, "cow"], "-") == "ant-bat-cow"
    end
  end

  describe "pluck" do
    test "plucks from enumerable" do
      [%{a: 1, b: 2}, %{a: 10, b: 20}, %{a: 100, b: 200}]
      |> Euclid.Enum.pluck(:a)
      |> assert_eq([1, 10, 100])
    end

    test "plucks multiple" do
      [%{a: 1, b: 2, c: 3}, %{a: 10, b: 20, c: 30}]
      |> Euclid.Enum.pluck([:a, :b])
      |> assert_eq([%{a: 1, b: 2}, %{a: 10, b: 20}])
    end
  end

  describe "update_or_append_by" do
    test "when list is empty, appends the mergeable" do
      []
      |> Euclid.Enum.update_or_append_by(&(&1.name == "John Doe"), %{name: "John Shmoe"})
      |> assert_eq([%{name: "John Shmoe"}])
    end

    test "when item does exist, merges with the existing item" do
      [%{name: "Jose Valim"}, %{name: "John Doe"}]
      |> Euclid.Enum.update_or_append_by(&(&1.name == "John Doe"), %{name: "John Shmoe"})
      |> assert_eq([%{name: "Jose Valim"}, %{name: "John Shmoe"}])
    end

    test "when item does not exist, appends mergeable to list" do
      [%{name: "Jose Valim"}, %{name: "John Doe"}]
      |> Euclid.Enum.update_or_append_by(&(&1.name == "FOO"), %{name: "Some New Person"})
      |> assert_eq([%{name: "Jose Valim"}, %{name: "John Doe"}, %{name: "Some New Person"}])
    end
  end
end
