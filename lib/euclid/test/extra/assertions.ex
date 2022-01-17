defmodule Euclid.Test.Extra.Assertions do
  @moduledoc deprecated: "Use `Euclid.Assertions` instead"

  # credo:disable-for-this-file

  import ExUnit.Assertions

  @deprecated "Use `Euclid.Assertions.assert_date_approximate/3` instead"
  def assert_datetime_approximate(left, right, delta \\ 1) do
    cond do
      NaiveDateTime.compare(right, NaiveDateTime.add(left, -delta, :second)) == :lt ->
        "Expected #{right} to be within #{delta} seconds of #{left}"
        |> flunk()

      NaiveDateTime.compare(right, NaiveDateTime.add(left, delta, :second)) == :gt ->
        "Expected #{right} to be within #{delta} seconds of #{left}"
        |> flunk()

      true ->
        left
    end
  end

  @deprecated "Use `Euclid.Assertions.assert_eq/3` instead"
  @spec assert_eq(any, any, keyword) :: any
  def assert_eq(left, right, opts \\ [])

  def assert_eq(left, right, opts) when is_list(left) and is_list(right) do
    {left, right} =
      if Keyword.get(opts, :ignore_order, false) do
        {Enum.sort(left), Enum.sort(right)}
      else
        {left, right}
      end

    assert left == right
    returning(opts, left)
  end

  def assert_eq(string, %Regex{} = regex, opts) when is_binary(string) do
    unless string =~ regex do
      ExUnit.Assertions.flunk("""
        Expected string to match regex
        left (string): #{string}
        right (regex): #{regex |> inspect}
      """)
    end

    returning(opts, string)
  end

  def assert_eq(left, right, opts) when is_map(left) and is_map(right) do
    {filtered_left, filtered_right} = filter_map(left, right, Keyword.get(opts, :only, :all), Keyword.get(opts, :except, :none))
    assert filtered_left == filtered_right
    returning(opts, left)
  end

  def assert_eq(left, right, opts) do
    assert left == right
    returning(opts, left)
  end

  defp returning(opts, default) when is_list(opts),
    do: opts |> Keyword.get(:returning, default)

  defp filter_map(left, right, :all, :none), do: {left, right}
  defp filter_map(left, right, :right_keys, :none), do: filter_map(left, right, Map.keys(right), :none)
  defp filter_map(left, right, keys, :none) when is_list(keys), do: {Map.take(left, keys), Map.take(right, keys)}
  defp filter_map(left, right, :all, keys) when is_list(keys), do: {Map.drop(left, keys), Map.drop(right, keys)}

  @deprecated "Use `Euclid.Assertions.assert_recent/1` instead"
  def assert_recent(nil) do
    flunk("Expected timestamp to be recent, but was nil")
  end

  def assert_recent(%NaiveDateTime{} = timestamp) do
    timestamp = timestamp |> NaiveDateTime.truncate(:second)
    now = NaiveDateTime.local_now()

    cond do
      NaiveDateTime.compare(timestamp, NaiveDateTime.add(now, -30, :second)) == :lt ->
        "Expected #{timestamp} to be recent, but was older than 30 seconds ago (as of #{now})"
        |> flunk()

      NaiveDateTime.compare(timestamp, NaiveDateTime.add(now, 1, :second)) == :gt ->
        "Expected #{timestamp} to be recent, but was more than 1 second into the future (as of #{now})"
        |> flunk()

      true ->
        timestamp
    end
  end

  def assert_recent(%DateTime{} = timestamp) do
    timestamp = timestamp |> DateTime.truncate(:second)
    now = DateTime.utc_now()

    cond do
      DateTime.compare(timestamp, DateTime.add(now, -30, :second)) == :lt ->
        "Expected #{timestamp} to be recent, but was older than 30 seconds ago (as of #{now})"
        |> flunk()

      DateTime.compare(timestamp, DateTime.add(now, 1, :second)) == :gt ->
        "Expected #{timestamp} to be recent, but was more than 1 second into the future (as of #{now})"
        |> flunk()

      true ->
        timestamp
    end
  end

  def assert_recent(datetime_string) when is_binary(datetime_string) do
    case DateTime.from_iso8601(datetime_string) do
      {:ok, datetime, 0} ->
        assert_recent(datetime)

      {:error, reason} ->
        "Expected DateTime “#{datetime_string}” to be recent, but it wasn't a valid DateTime in ISO8601 format: #{inspect(reason)}"
        |> flunk()
    end
  end

  @spec assert_that(any, [{:changes, any} | {:from, any} | {:to, any}, ...]) :: {:__block__, [], [...]}
  @deprecated "Use `Euclid.Assertions.assert_that/3` instead"
  defmacro assert_that(command, changes: check, from: from, to: to) do
    quote do
      try do
        assert unquote(check) == unquote(from)
      rescue
        error in ExUnit.AssertionError ->
          raise %{error | message: "Pre-condition failed"}
      end

      unquote(command)

      try do
        assert unquote(check) == unquote(to)
      rescue
        error in ExUnit.AssertionError ->
          raise %{error | message: "Post-condition failed"}
      end
    end
  end
end
