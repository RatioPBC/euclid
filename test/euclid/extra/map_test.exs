defmodule Euclid.Extra.MapTest do
  use Euclid.SimpleCase, async: true

  alias Euclid.Extra

  describe "all values empty" do
    test "returns true if all values are empty" do
      %{"dob" => "", "exposure_date" => "", "full_name" => "", "gender" => "", "name" => ""}
      |> Extra.Map.all_values_blank?()
      |> assert_eq(true)
    end

    test "returns false if not all values are empty" do
      %{"dob" => "", "exposure_date" => "", "full_name" => "Not Empty", "gender" => "", "name" => ""}
      |> Extra.Map.all_values_blank?()
      |> assert_eq(false)
    end
  end

  describe "atomize_keys" do
    test "converts keys from strings to atoms" do
      %{"item1" => "chapstick", "item2" => "mask"}
      |> Extra.Map.atomize_keys()
      |> assert_eq(%{item1: "chapstick", item2: "mask"})
    end

    test "handles keys that are already atoms" do
      %{:item1 => 1, "item2" => 2}
      |> Extra.Map.atomize_keys()
      |> assert_eq(%{item1: 1, item2: 2})
    end

    test "handles a list of maps" do
      [%{a: :b}, %{"d" => :f}]
      |> Extra.Map.deep_atomize_keys()
      |> assert_eq([%{a: :b}, %{d: :f}])
    end
  end

  describe "deep_atomize_keys" do
    test "deeply converts keys from strings to atoms" do
      %{"item1" => "chapstick", "item2" => %{"item3" => "mask"}}
      |> Extra.Map.deep_atomize_keys()
      |> assert_eq(%{item1: "chapstick", item2: %{item3: "mask"}})
    end

    test "handles keys that are already atoms" do
      %{:item1 => %{"item3" => "mask"}, "item2" => 2}
      |> Extra.Map.deep_atomize_keys()
      |> assert_eq(%{item1: %{item3: "mask"}, item2: 2})
    end

    test "handles values that are lists" do
      %{
        "item1" => "chapstick",
        "item2" => %{"item3" => ["mask", "altoids"], "item4" => [%{"size" => "s", "color" => "blue"}, %{"size" => "m", "color" => "red"}]}
      }
      |> Extra.Map.deep_atomize_keys()
      |> assert_eq(%{item1: "chapstick", item2: %{item3: ["mask", "altoids"], item4: [%{size: "s", color: "blue"}, %{size: "m", color: "red"}]}})
    end
  end

  describe "merge" do
    test "with two maps" do
      %{a: 1, b: 2} |> Extra.Map.merge(%{b: 3, c: 4}) |> assert_eq(%{a: 1, b: 3, c: 4})
    end

    test "with other enumerables" do
      %{a: 1, b: 2} |> Extra.Map.merge(b: 3, c: 4) |> assert_eq(%{a: 1, b: 3, c: 4})
      [a: 1, b: 2] |> Extra.Map.merge(%{b: 3, c: 4}) |> assert_eq(%{a: 1, b: 3, c: 4})
    end
  end

  describe "rename_key" do
    test "renames a key" do
      %{"color" => "red", "size" => "medium"}
      |> Extra.Map.rename_key("color", "colour")
      |> assert_eq(%{"colour" => "red", "size" => "medium"})
    end

    test "accepts tuple for renaming" do
      %{"color" => "red", "size" => "medium"}
      |> Extra.Map.rename_key({"color", "colour"})
      |> assert_eq(%{"colour" => "red", "size" => "medium"})
    end

    test "does nothing if the key doesn't exist" do
      %{"color" => "red", "size" => "medium"}
      |> Extra.Map.rename_key("behavior", "behaviour")
      |> assert_eq(%{"color" => "red", "size" => "medium"})
    end

    test "renames the key if the value is nil" do
      %{"color" => nil, "size" => "medium"}
      |> Extra.Map.rename_key("color", "colour")
      |> assert_eq(%{"colour" => nil, "size" => "medium"})
    end
  end

  describe "rename_keys" do
    test "renames multiple keys" do
      %{"behavior" => "chill", "color" => "red", "size" => "medium"}
      |> Extra.Map.rename_keys(%{"behavior" => "behaviour", "color" => "colour"})
      |> assert_eq(%{"behaviour" => "chill", "colour" => "red", "size" => "medium"})
    end

    test "does nothing if the key doesn't exist" do
      %{"color" => "red", "size" => "medium"}
      |> Extra.Map.rename_keys(%{"behavior" => "behaviour"})
      |> assert_eq(%{"color" => "red", "size" => "medium"})
    end

    test "renames the key if the value is nil" do
      %{"color" => nil, "size" => "medium"}
      |> Extra.Map.rename_keys(%{"behavior" => "behaviour"})
      |> assert_eq(%{"color" => nil, "size" => "medium"})
    end
  end

  describe "stringify_keys" do
    test "converts keys from atoms to strings" do
      %{item1: "chapstick", item2: "mask"}
      |> Extra.Map.stringify_keys()
      |> assert_eq(%{"item1" => "chapstick", "item2" => "mask"})
    end

    test "gracefully handles keys that are already strings" do
      %{"item1" => "chapstick", "item2" => "mask"}
      |> Extra.Map.stringify_keys()
      |> assert_eq(%{"item1" => "chapstick", "item2" => "mask"})

      assert_raise ArgumentError, fn ->
        Extra.Map.stringify_keys(%{nil => 1})
      end
    end
  end

  describe "transform" do
    test "transforms values using the transform function" do
      %{"foo" => "chicken", "bar" => "cow", "baz" => "pig"}
      |> Extra.Map.transform(["foo", "bar"], &String.upcase/1)
      |> assert_eq(%{"foo" => "CHICKEN", "bar" => "COW", "baz" => "pig"})
    end

    test "does nothing if a key doesn't exist" do
      %{"foo" => "chicken", "bar" => "cow"}
      |> Extra.Map.transform(["foo", "baz"], &String.upcase/1)
      |> assert_eq(%{"foo" => "CHICKEN", "bar" => "cow"})
    end

    test "it accepts a string" do
      %{"foo" => "chicken", "bar" => "cow"}
      |> Extra.Map.transform("foo", &String.upcase/1)
      |> assert_eq(%{"foo" => "CHICKEN", "bar" => "cow"})
    end
  end
end
