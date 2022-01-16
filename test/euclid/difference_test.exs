defmodule Euclid.DifferenceTest do
  use Euclid.SimpleCase, async: true

  test "for numbers, returns the difference" do
    assert Euclid.Difference.diff(10, 5) == 5
    assert Euclid.Difference.diff(5, 10) == -5
  end

  test "for DateTime, returns the difference in microseconds" do
    assert Euclid.Difference.diff(~U[2020-01-01T00:00:01.234567Z], ~U[2020-01-01T00:00:00.000Z]) == 1_234_567
  end

  test "for NaiveDateTime, returns the difference in microseconds" do
    assert Euclid.Difference.diff(~N[2020-01-01T00:00:01.234567Z], ~N[2020-01-01T00:00:00.000Z]) == 1_234_567
  end

  test "for strings, converts to DateTime and returns the difference in microseconds" do
    assert Euclid.Difference.diff(~N[2020-01-01T00:00:01.234567Z], ~N[2020-01-01T00:00:00.000Z]) == 1_234_567
  end
end
