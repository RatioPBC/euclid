defmodule Euclid.ExistsTest do
  use ExUnit.Case, async: true

  test "nil is blank", do: assert(nil |> Euclid.Exists.blank?())

  test "strings" do
    assert Euclid.Exists.blank?("") == true
    assert Euclid.Exists.present?("") == false
    assert Euclid.Exists.blank?("    ") == true
    assert Euclid.Exists.present?("   ") == false
    assert Euclid.Exists.blank?("hi") == false
    assert Euclid.Exists.present?("hi") == true
  end

  describe "any?" do
    test "is true if any items are present" do
      assert Euclid.Exists.any?([nil, "", " ", 43])
    end

    test "is false if no items are present" do
      refute Euclid.Exists.any?([nil, "", " ", false])
    end
  end

  describe "join" do
    test "joins present items" do
      assert Euclid.Exists.join(["ant", "", "bat", nil, "cow"]) == "ant bat cow"
      assert Euclid.Exists.join(["ant", "", "bat", nil, "cow"], "-") == "ant-bat-cow"
    end
  end

  describe "other scalars blank?" do
    test "numeric is not blank", do: refute(5 |> Euclid.Exists.blank?())
    test "true is not blank", do: refute(true |> Euclid.Exists.blank?())
    test "false is blank", do: assert(false |> Euclid.Exists.blank?())
  end

  describe "list blank?" do
    test "empty list is blank", do: assert([] |> Euclid.Exists.blank?())
    test "non-empty list is not black", do: refute(["foo"] |> Euclid.Exists.blank?())
  end

  describe "map blank?" do
    test "empty map is blank", do: assert(%{} |> Euclid.Exists.blank?())
    test "non-empty map is not blank", do: refute(%{foo: :bar} |> Euclid.Exists.blank?())
  end

  test "present?", do: assert("binary" |> Euclid.Exists.present?())

  describe "presence" do
    test "returns input if present", do: assert(Euclid.Exists.presence("thing") == "thing")
    test "returns nil if not present", do: assert(Euclid.Exists.presence("    ") == nil)
  end

  describe "first_present" do
    test "returns the first item in the list that is not blank" do
      assert Euclid.Exists.first_present([nil, "", [], %{}, "x", "y"]) == "x"
    end

    test "returns nil if everything is blank" do
      assert Euclid.Exists.first_present([nil, "", []]) == nil
    end
  end

  describe "or_default" do
    test "returns value when value is present", do: assert(5 |> Euclid.Exists.or_default(10) == 5)
    test "returns default when value is not present", do: assert(nil |> Euclid.Exists.or_default(10) == 10)
  end

  describe "filtering" do
    test "filters in present values" do
      assert Euclid.Exists.filter([nil, "not nil", [], %{}]) == ["not nil"]
    end
  end
end
