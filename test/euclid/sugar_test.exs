defmodule Euclid.SugarTest do
  use ExUnit.Case, async: true
  doctest Euclid.Sugar

  describe "error" do
    test "wraps the given term in an :error tuple" do
      assert Euclid.Sugar.error(1) == {:error, 1}
    end
  end

  describe "error!" do
    test "unwraps an :error tuple" do
      assert Euclid.Sugar.error!({:error, 1}) == 1
    end

    test "fails when it's not an :error tuple" do
      assert_raise FunctionClauseError, "no function clause matching in Euclid.Sugar.error!/1", fn -> Euclid.Sugar.error!({:ok, :good}) end
      assert_raise FunctionClauseError, "no function clause matching in Euclid.Sugar.error!/1", fn -> Euclid.Sugar.error!(:good) end
    end
  end

  describe "noreply" do
    test "wraps the given term in a :noreply tuple" do
      assert Euclid.Sugar.noreply(1) == {:noreply, 1}
    end
  end

  describe "ok" do
    test "wraps the given term in an :ok tuple" do
      assert Euclid.Sugar.ok(1) == {:ok, 1}
    end
  end

  describe "ok!" do
    test "unwraps an :ok tuple" do
      assert Euclid.Sugar.ok!({:ok, 1}) == 1
    end

    test "fails when it's not an :ok tuple" do
      assert_raise FunctionClauseError, "no function clause matching in Euclid.Sugar.ok!/1", fn -> Euclid.Sugar.ok!({:error, :bad}) end
      assert_raise FunctionClauseError, "no function clause matching in Euclid.Sugar.ok!/1", fn -> Euclid.Sugar.ok!(:bad) end
    end
  end

  describe "returning" do
    test "accepts two values and returns the second" do
      assert Euclid.Sugar.returning(1, 2) == 2
    end
  end
end
