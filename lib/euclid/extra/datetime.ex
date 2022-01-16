defmodule Euclid.Extra.DateTime do
  @moduledoc deprecated: "Use `Euclid.DateTime` instead"

  @deprecated "Use `Euclid.DateTime.to_iso8601/2` instead"
  def to_iso8601(date, :rounded), do: date |> DateTime.truncate(:second) |> DateTime.to_iso8601()
end
