defmodule Euclid.ProtocolTest do
  use Euclid.SimpleCase, async: true

  describe "implements!" do
    test "returns the first param if it implements the given protocol" do
      assert Euclid.Protocol.implements!(Date.new!(2000, 1, 2), String.Chars)
    end

    test "raises an exception if the first param does not implement the given protocol" do
      assert_raise RuntimeError, "Expected ~D[2000-01-02] to implement protocol Enumerable", fn ->
        Euclid.Protocol.implements!(Date.new!(2000, 1, 2), Enumerable)
      end
    end
  end
end
