defmodule Euclid.AtomTest do
  use Euclid.SimpleCase, async: true

  describe "from_string" do
    test "string", do: assert(Euclid.Atom.from_string("banana") == :banana)
    test "already an atom", do: assert(Euclid.Atom.from_string(:banana) == :banana)
    test "nil", do: assert_raise(ArgumentError, fn -> Euclid.Atom.from_string(nil) end)
  end

  describe "to_string" do
    test "atom", do: assert(Euclid.Atom.to_string(:banana) == "banana")
    test "already a string", do: assert(Euclid.Atom.to_string("banana") == "banana")
    test "nil", do: assert_raise(ArgumentError, fn -> Euclid.Atom.to_string(nil) end)
  end
end
