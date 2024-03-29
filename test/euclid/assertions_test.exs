defmodule Euclid.AssertionsTest do
  use Euclid.SimpleCase, async: true

  describe "assert_eq" do
    test "returns its first arg if the assertion passes" do
      assert assert_eq("arg", "arg") == "arg"
    end

    test "can optionally return something else, to make piping more fun" do
      assert assert_eq("arg", "arg", returning: "something else") == "something else"
    end

    test "when the `within` option is given, equality does not have to be exact" do
      assert_eq 1.1, 1.08, within: 0.1

      assert_raise ExUnit.AssertionError,
                   ~s|\n\nExpected "1.1" to be within 0.01 of "1.08"\n|,
                   fn -> assert_eq 1.1, 1.08, within: 0.01 end
    end

    test "when the arguments are maps, and no options are given, performs a regular map equality test" do
      assert_eq %{a: 1, b: 2}, %{b: 2, a: 1}
      assert_raise ExUnit.AssertionError, fn -> assert_eq %{a: 9, b: 9}, %{b: 2, a: 1} end
    end

    test "when the arguments are maps, the `only` option compares only the desired keys" do
      left = %{desired: 1, random: 123}
      right = %{desired: 1, random: 2_039_420_423}
      assert_eq left, right, only: [:desired]
    end

    test "when the arguments are maps, the `except` option ignores undesired keys" do
      left = %{desired: 1, random: 123}
      right = %{desired: 1, random: 2_039_420_423}
      assert_eq left, right, except: [:random]
    end

    test "when the arguments are maps, the `only: :right_keys` option compares only keys found in the right map" do
      left = %{desired: 1, desired_2: 2, random: 123}
      right = %{desired: 1, desired_2: 2}

      assert_eq left, right, only: :right_keys
      assert_eq left, right, only: :right_keys
      assert_eq Range.new(1, 5), %{first: 1}, only: :right_keys
    end

    test "when the arguments are maps, returns the full left argument even if only some parts were used for the assertion" do
      left = %{desired: 1, random: 123}
      right = %{desired: 1, random: 2_039_420_423}
      assert assert_eq(left, right, only: [:desired]) == left
    end

    test "when the first argument is a string and the second is a regex, it performs a regex match" do
      assert_eq "foo", ~r/foo/
      assert_raise ExUnit.AssertionError, fn -> assert_eq("foo", ~r/bar/) end
    end

    test "when the arguments are lists, and the `ignore_order: true` option is not given, it fails if the lists are not in the same order" do
      assert_raise ExUnit.AssertionError, fn -> assert_eq([1, 2, 3], [3, 2, 1]) end
      assert_raise ExUnit.AssertionError, fn -> assert_eq([1, 2, 3], [3, 2, 1], ignore_order: false) end
    end

    test "when the arguments are lists, the `ignore_order: true` option compares without respect to order" do
      assert_eq [1, 2, 3], [3, 2, 1], ignore_order: true
    end

    test "when the arguments are DateTimes" do
      assert_eq ~U[2020-01-01T00:00:00Z], ~U[2020-01-01T00:00:00Z]
      assert_raise ExUnit.AssertionError, fn -> assert_eq ~U[2020-01-01T00:00:00Z], ~U[2020-01-02T00:00:00Z] end
    end

    test "when the arguments are DateTimes, and the `within: {delta, unit}` option is given, it succeeds when the datetimes are within the delta" do
      assert_eq ~U[2020-01-01T00:00:00Z], ~U[2020-01-01T00:01:59Z], within: {2, :minute}
      assert_raise ExUnit.AssertionError, fn -> assert_eq ~U[2020-01-01T00:00:00Z], ~U[2020-01-02T00:02:01Z], within: {2, :minute} end
    end

    test "when the arguments are NaiveDateTimes, and the `within: {delta, unit}` option is given, it succeeds when the datetimes are within the delta" do
      assert_eq ~N[2020-01-01T00:00:00Z], ~N[2020-01-01T00:01:59Z], within: {2, :minute}
      assert_raise ExUnit.AssertionError, fn -> assert_eq ~N[2020-01-01T00:00:00Z], ~N[2020-01-02T00:02:01Z], within: {2, :minute} end
    end

    test "when the arguments are strings, and the `within: {delta, unit}` option is given, it converts from ISO8601 and succeeds when the datetimes are within the delta" do
      assert_eq "2020-01-01T00:00:00Z", "2020-01-01T00:01:59Z", within: {2, :minute}
      assert_raise ExUnit.AssertionError, fn -> assert_eq "2020-01-01T00:00:00Z", "2020-01-02T00:02:01Z", within: {2, :minute} end
    end
  end

  describe "assert_that" do
    test "is happy when the experiment works as expected" do
      {:ok, agent} = Agent.start(fn -> 0 end)

      assert_that(Agent.update(agent, fn s -> s + 1 end),
        changes: Agent.get(agent, fn s -> s end),
        from: 0,
        to: 1
      )
    end

    test "complains when the precondition is not fulfilled" do
      {:ok, agent} = Agent.start(fn -> 0 end)

      assert_raise ExUnit.AssertionError,
                   """


                   Pre-condition failed
                   code:  assert Agent.get(agent, fn s -> s end) == 9
                   left:  0
                   right: 9
                   """,
                   fn ->
                     assert_that(Agent.update(agent, fn s -> s + 1 end),
                       changes: Agent.get(agent, fn s -> s end),
                       from: 9,
                       to: 1
                     )
                   end
    end

    test "complains when the postcondition is not fulfilled" do
      {:ok, agent} = Agent.start(fn -> 0 end)

      assert_raise ExUnit.AssertionError,
                   """


                   Post-condition failed
                   code:  assert Agent.get(agent, fn s -> s end) == 2
                   left:  1
                   right: 2
                   """,
                   fn ->
                     assert_that(Agent.update(agent, fn s -> s + 1 end),
                       changes: Agent.get(agent, fn s -> s end),
                       from: 0,
                       to: 2
                     )
                   end
    end
  end

  describe "assert_recent" do
    test "with a DateTime, passes when it is no more than 30 seconds old" do
      DateTime.utc_now() |> DateTime.add(-29, :second) |> assert_recent()
    end

    test "with a DateTime, fails it is older than 30 seconds" do
      time = DateTime.utc_now() |> DateTime.add(-31, :second)
      expected_message = ~r|Expected #{DateTime.truncate(time, :second)} to be recent, but was older than 30 seconds ago|
      assert_raise ExUnit.AssertionError, expected_message, fn -> time |> assert_recent() end
    end

    test "with a DateTime, passes when it is no more than 1 second into the future" do
      DateTime.utc_now() |> DateTime.add(500, :millisecond) |> assert_recent()
    end

    test "with a DateTime, fails when it is more than 1 second into the future" do
      time = DateTime.utc_now() |> DateTime.add(2, :second)
      expected_message = ~r|Expected #{DateTime.truncate(time, :second)} to be recent, but was more than 1 second into the future|
      assert_raise ExUnit.AssertionError, expected_message, fn -> time |> assert_recent() end
    end

    test "with a NaiveDateTime, passes when it is within 30 seconds of local time" do
      NaiveDateTime.local_now() |> NaiveDateTime.add(-29, :second) |> assert_recent()
    end

    test "with a NaiveDateTime, fails when it is older than 30 seconds" do
      time = NaiveDateTime.local_now() |> NaiveDateTime.add(-31, :second)
      expected_message = ~r|Expected #{NaiveDateTime.truncate(time, :second)} to be recent, but was older than 30 seconds ago|
      assert_raise ExUnit.AssertionError, expected_message, fn -> time |> assert_recent() end
    end

    test "with a NaiveDateTime, passes when it is no more than 1 second into the future" do
      NaiveDateTime.local_now() |> NaiveDateTime.add(500, :millisecond) |> assert_recent()
    end

    test "with a NaiveDateTime, fails when it is more than 1 second into the future" do
      time = NaiveDateTime.local_now() |> NaiveDateTime.add(2, :second)
      expected_message = ~r|Expected #{NaiveDateTime.truncate(time, :second)} to be recent, but was more than 1 second into the future|
      assert_raise ExUnit.AssertionError, expected_message, fn -> time |> assert_recent() end
    end

    test "flunks when datetime is nil" do
      expected_message = ~r|Expected timestamp to be recent, but was nil|
      assert_raise ExUnit.AssertionError, expected_message, fn -> assert_recent(nil) end
    end

    test "with a valid ISO8601 string, converts to a DateTime" do
      DateTime.utc_now() |> DateTime.add(-29, :second) |> DateTime.to_iso8601() |> assert_recent()
    end

    test "with an invalid ISO8601 string, blows up" do
      expected = ~r|Expected DateTime “glorp” to be recent, but it wasn't a valid DateTime in ISO8601 format: :invalid_format|
      assert_raise ExUnit.AssertionError, expected, fn -> "glorp" |> assert_recent() end

      now = ~N[2021-01-02T03:04:05.123456]

      expected = ~r|Expected DateTime “2021-01-02T03:04:05.123456” to be recent, but it wasn't a valid DateTime in ISO8601 format: :missing_offset|
      assert_raise ExUnit.AssertionError, expected, fn -> now |> NaiveDateTime.to_iso8601() |> assert_recent() end
    end
  end
end
