defmodule Euclid.Extra.AtomTest do
  use Euclid.SimpleCase, async: true

  alias Euclid.Extra

  describe "from_string" do
    test "string", do: assert(Extra.Atom.from_string("banana") == :banana)
    test "already an atom", do: assert(Extra.Atom.from_string(:banana) == :banana)
    test "nil", do: assert_raise(ArgumentError, fn -> Extra.Atom.from_string(nil) end)
  end

  describe "to_string" do
    test "atom", do: assert(Extra.Atom.to_string(:banana) == "banana")
    test "already a string", do: assert(Extra.Atom.to_string("banana") == "banana")
    test "nil", do: assert_raise(ArgumentError, fn -> Extra.Atom.to_string(nil) end)
  end
end
