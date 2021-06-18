defmodule Euclid.Test.Extra.AssertionsTest do
  use Euclid.SimpleCase, async: true

  describe "assert_eq" do
    test "returns its first arg if the assertion passes" do
      assert assert_eq("arg", "arg") == "arg"
    end

    test "can optionally return something else, to make piping more fun" do
      assert assert_eq("arg", "arg", returning: "something else") == "something else"
    end

    test "compares only the desired keys in maps" do
      left = %{desired: 1, random: 123}
      right = %{desired: 1, random: 2_039_420_423}
      assert_eq(left, right, only: [:desired])
    end

    test "ignores undesired keys in maps" do
      left = %{desired: 1, random: 123}
      right = %{desired: 1, random: 2_039_420_423}
      assert_eq(left, right, except: [:random])
    end

    test "compares only keys found in the right map" do
      left = %{desired: 1, desired_2: 2, random: 123}
      right = %{desired: 1, desired_2: 2}

      assert_eq(left, right, only: :right_keys)
      assert_eq(left, right, only: :right_keys)
      assert_eq(Range.new(1, 5), %{first: 1}, only: :right_keys)
    end

    test "returns the full left argument even if only some parts were used for the assertion" do
      left = %{desired: 1, random: 123}
      right = %{desired: 1, random: 2_039_420_423}
      assert assert_eq(left, right, only: [:desired]) == left
    end

    test "compares a string with a regex" do
      assert_eq("foo", ~r/foo/)
      assert_raise ExUnit.AssertionError, fn -> assert_eq("foo", ~r/bar/) end
    end

    test "compares maps" do
      assert_eq(%{a: 1, b: 2}, %{b: 2, a: 1})
      assert_raise ExUnit.AssertionError, fn -> assert_eq(%{a: 9, b: 9}, %{b: 2, a: 1}) end
    end

    test "compares lists, ignoring order" do
      assert_eq([1, 2, 3], [3, 2, 1], ignore_order: true)
    end

    test "compares lists, without ignoring order" do
      assert_raise ExUnit.AssertionError, fn -> assert_eq([1, 2, 3], [3, 2, 1]) end
      assert_raise ExUnit.AssertionError, fn -> assert_eq([1, 2, 3], [3, 2, 1], ignore_order: false) end
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


                   Assertion with == failed
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


                   Assertion with == failed
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

  describe "assert_datetime_approximate" do
    setup do
      datetime = ~U[2020-01-01 12:00:00Z]
      %{datetime: datetime}
    end

    test "passes when datetimes are within one second of each other by default", %{datetime: datetime} do
      assert_datetime_approximate(datetime, datetime)

      one_second_later = DateTime.add(datetime, 1, :second)
      assert_datetime_approximate(datetime, one_second_later)

      one_second_earlier = DateTime.add(datetime, -1, :second)
      assert_datetime_approximate(datetime, one_second_earlier)
    end

    test "flunks when datetime are >= one second apart by default", %{datetime: datetime} do
      one_second_later = DateTime.add(datetime, 2, :second)

      assert_raise ExUnit.AssertionError, "\n\nExpected 2020-01-01 12:00:02Z to be within 1 seconds of 2020-01-01 12:00:00Z\n", fn ->
        assert_datetime_approximate(datetime, one_second_later)
      end

      one_second_earlier = DateTime.add(datetime, -2, :second)

      assert_raise ExUnit.AssertionError, "\n\nExpected 2020-01-01 11:59:58Z to be within 1 seconds of 2020-01-01 12:00:00Z\n", fn ->
        assert_datetime_approximate(datetime, one_second_earlier)
      end
    end

    test "passes when datetimes are within provided delta", %{datetime: datetime} do
      five_seconds_later = DateTime.add(datetime, 5, :second)
      assert_datetime_approximate(datetime, five_seconds_later, 5)

      five_seconds_earlier = DateTime.add(datetime, -5, :second)
      assert_datetime_approximate(datetime, five_seconds_earlier, 5)
    end

    test "flunks when datetimes are outside provided delta", %{datetime: datetime} do
      six_seconds_later = DateTime.add(datetime, 6, :second)

      assert_raise ExUnit.AssertionError, "\n\nExpected 2020-01-01 12:00:06Z to be within 5 seconds of 2020-01-01 12:00:00Z\n", fn ->
        assert_datetime_approximate(datetime, six_seconds_later, 5)
      end

      six_seconds_earlier = DateTime.add(datetime, -6, :second)

      assert_raise ExUnit.AssertionError, "\n\nExpected 2020-01-01 11:59:54Z to be within 5 seconds of 2020-01-01 12:00:00Z\n", fn ->
        assert_datetime_approximate(datetime, six_seconds_earlier, 5)
      end
    end

    test "returns first argument if valid", %{datetime: datetime} do
      assert assert_datetime_approximate(datetime, datetime) == datetime
    end
  end
end
