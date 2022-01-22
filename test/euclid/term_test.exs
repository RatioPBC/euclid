defmodule Euclid.TermTest do
  use Euclid.SimpleCase, async: true

  describe "blank?" do
    test "booleans: true is not blank, false is blank" do
      refute Euclid.Term.blank?(true)
      assert Euclid.Term.blank?(false)
    end

    test "lists: blank if empty" do
      assert Euclid.Term.blank?([])
      refute Euclid.Term.blank?([nil])
      refute Euclid.Term.blank?([1])
    end

    test "maps: blank if empty" do
      assert Euclid.Term.blank?(%{})
      refute Euclid.Term.blank?(%{a: nil})
      refute Euclid.Term.blank?(%{a: 1})
    end

    test "nil: is blank" do
      assert Euclid.Term.blank?(nil)
    end

    test "numbers: never blank" do
      refute Euclid.Term.blank?(0)
      refute Euclid.Term.blank?(1000)
    end

    test "strings: blank if empty or just whitespace" do
      assert Euclid.Term.blank?("")
      assert Euclid.Term.blank?("    ")
      refute Euclid.Term.blank?("hi")
    end
  end

  describe "present?" do
    test "returns the opposite of `blank?`" do
      assert Euclid.Term.blank?("")
      refute Euclid.Term.present?("")

      refute Euclid.Term.blank?("something")
      assert Euclid.Term.present?("something")
    end
  end

  describe "presence" do
    test "if the value is present (via `present?`), returns the value" do
      assert Euclid.Term.presence("foo") == "foo"
      assert Euclid.Term.presence("foo", "default") == "foo"
    end

    test "if the value is not present (via `present?`), returns the default value" do
      assert Euclid.Term.presence(" ") == nil
      assert Euclid.Term.presence(" ", "default") == "default"
    end
  end
end
