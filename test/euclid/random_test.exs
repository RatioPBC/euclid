defmodule Euclid.RandomTest do
  use Euclid.SimpleCase, async: true

  describe "string" do
    test "defaults to 32 characters" do
      assert String.length(Euclid.Random.string()) == 32
    end

    test "returns a string with the given length" do
      assert String.length(Euclid.Random.string(5)) == 5
      assert String.length(Euclid.Random.string(59)) == 59
    end

    test "returns strings that don't collide" do
      refute Euclid.Random.string(59) == Euclid.Random.string(59)
    end

    test "can be base64 encoded (the default)" do
      for _ <- 1..1000 do
        assert Euclid.Random.string() =~ ~r|^[A-Za-z0-9+/]{32}$|
        assert Euclid.Random.string(:base64) =~ ~r|^[A-Za-z0-9+/]{32}$|
        assert Euclid.Random.string(20) =~ ~r|^[A-Za-z0-9+/]{20}$|
        assert Euclid.Random.string(10, :base64) =~ ~r|^[A-Za-z0-9+/]{10}$|
      end
    end

    test "can be base32 encoded" do
      for _ <- 1..1000 do
        assert Euclid.Random.string(:base32) =~ ~r|^[A-Z2-7]{32}$|
        assert Euclid.Random.string(20, :base32) =~ ~r|^[A-Z2-7]{20}$|
      end
    end
  end
end
