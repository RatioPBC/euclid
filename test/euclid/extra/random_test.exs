defmodule Euclid.Extra.RandomTest do
  use Euclid.SimpleCase, async: true

  alias Euclid.Extra

  describe "string" do
    test "returns a string with the given length" do
      assert String.length(Extra.Random.string(5)) == 5
      assert String.length(Extra.Random.string(59)) == 59
    end

    test "returns strings that don't collide" do
      refute Extra.Random.string(59) == Extra.Random.string(59)
    end
  end
end
