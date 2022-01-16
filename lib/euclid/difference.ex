defprotocol Euclid.Difference do
  @fallback_to_any true
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
