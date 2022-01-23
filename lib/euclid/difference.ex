defprotocol Euclid.Difference do
  @fallback_to_any true

  @doc """
  Returns the difference between `a` and `b`.
  The fallback implementation uses `Kernel.-/2` to subtract `b` from `a`.
  """
  @spec diff(any(), any()) :: any()
  def diff(a, b)
end

defimpl Euclid.Difference, for: Any do
  def diff(a, b), do: a - b
end

defimpl Euclid.Difference, for: DateTime do
  def diff(a, b), do: DateTime.diff(a, b, :microsecond)
end

defimpl Euclid.Difference, for: NaiveDateTime do
  def diff(a, b), do: NaiveDateTime.diff(a, b, :microsecond)
end

defimpl Euclid.Difference, for: BitString do
  def diff(a, b), do: DateTime.diff(Euclid.DateTime.from_iso8601!(a), Euclid.DateTime.from_iso8601!(b), :microsecond)
end
