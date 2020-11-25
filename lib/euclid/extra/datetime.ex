defmodule Euclid.Extra.DateTime do
  def to_iso8601(date, :rounded), do: date |> DateTime.truncate(:second) |> DateTime.to_iso8601()
end
