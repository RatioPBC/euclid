defmodule Euclid.DurationTest do
  use Euclid.SimpleCase, async: true
  doctest Euclid.Duration

  test "convert" do
    assert Euclid.Duration.convert({1, :second}, :millisecond) == 1000
    assert Euclid.Duration.convert({23, :second}, :millisecond) == 23000
    assert Euclid.Duration.convert({1001, :millisecond}, :second) == 1
    assert Euclid.Duration.convert({121, :second}, :minute) == 2
    assert Euclid.Duration.convert({121, :minute}, :hour) == 2
    assert Euclid.Duration.convert({49, :hour}, :day) == 2
  end

  test "to_string" do
    assert Euclid.Duration.to_string({1, :second}) == "1 second"
    assert Euclid.Duration.to_string({-1, :minute}) == "-1 minute"
    assert Euclid.Duration.to_string({23, :hour}) == "23 hours"
  end
end
