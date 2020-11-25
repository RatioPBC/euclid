defmodule Euclid.ExistsTest do
  use ExUnit.Case, async: true

  alias Euclid.Exists

  test "nil is blank", do: assert(nil |> Exists.blank?())

  test "strings" do
    assert Exists.blank?("") == true
    assert Exists.present?("") == false
    assert Exists.blank?("    ") == true
    assert Exists.present?("   ") == false
    assert Exists.blank?("hi") == false
    assert Exists.present?("hi") == true
  end

  describe "any?" do
    test "is true if any items are present" do
      assert Exists.any?([nil, "", " ", 43])
    end

    test "is false if no items are present" do
      refute Exists.any?([nil, "", " ", false])
    end
  end

  describe "join" do
    test "joins present items" do
      assert Exists.join(["ant", "", "bat", nil, "cow"]) == "ant bat cow"
      assert Exists.join(["ant", "", "bat", nil, "cow"], "-") == "ant-bat-cow"
    end
  end

  describe "other scalars blank?" do
    test "numeric is not blank", do: refute(5 |> Exists.blank?())
    test "true is not blank", do: refute(true |> Exists.blank?())
    test "false is blank", do: assert(false |> Exists.blank?())
  end

  describe "list blank?" do
    test "empty list is blank", do: assert([] |> Exists.blank?())
    test "non-empty list is not black", do: refute(["foo"] |> Exists.blank?())
  end

  describe "map blank?" do
    test "empty map is blank", do: assert(%{} |> Exists.blank?())
    test "non-empty map is not blank", do: refute(%{foo: :bar} |> Exists.blank?())
  end

  test "present?", do: assert("binary" |> Exists.present?())

  describe "presence" do
    test "returns input if present", do: assert(Exists.presence("thing") == "thing")
    test "returns nil if not present", do: assert(Exists.presence("    ") == nil)
  end

  describe "first_present" do
    test "returns the first item in the list that is not blank" do
      assert Exists.first_present([nil, "", [], %{}, "x", "y"]) == "x"
    end

    test "returns nil if everything is blank" do
      assert Exists.first_present([nil, "", []]) == nil
    end
  end

  describe "or_default" do
    test "returns value when value is present", do: assert(5 |> Exists.or_default(10) == 5)
    test "returns default when value is not present", do: assert(nil |> Exists.or_default(10) == 10)
  end

  describe "filtering" do
    test "filters in present values" do
      assert Exists.filter([nil, "not nil", [], %{}]) == ["not nil"]
    end
  end
end
