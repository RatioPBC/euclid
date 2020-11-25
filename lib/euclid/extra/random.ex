defmodule Euclid.Extra.Random do
  @moduledoc """
  Helpers for generating random data in whatever format
  """

  @doc """
  Returns a base64 encoded string of given length

  ## Examples
      iex> Euclid.Extra.Random.string()
      "Sr/y4m/YiVSJcIgI5lG+76vMfaZ7KZ7c"
      iex> Euclid.Extra.Random.string(5)
      "9pJrK"
  """
  @spec string(character_count :: pos_integer()) :: binary()
  def string(character_count \\ 32) do
    character_count
    |> :crypto.strong_rand_bytes()
    |> Base.encode64(padding: false)
    |> binary_part(0, character_count)
  end
end
