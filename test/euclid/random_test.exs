defmodule Euclid.RandomTest do
  use Euclid.SimpleCase, async: true

  describe "string" do
    test "returns a string with the given length" do
      assert String.length(Euclid.Random.string(5)) == 5
      assert String.length(Euclid.Random.string(59)) == 59
    end

    test "returns strings that don't collide" do
      refute Euclid.Random.string(59) == Euclid.Random.string(59)
    end
  end
end
