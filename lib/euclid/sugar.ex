defmodule Euclid.Sugar do
  @moduledoc "Some common syntactic sugar functions, probably best used by importing the whole module"

  @doc """
  Wraps a term in an :error tuple. Useful in pipelines.

  ## Examples

      iex> %{} |> Map.put(:count, "unknown") |> Euclid.Sugar.error()
      {:error, %{count: "unknown"}}
  """
  @spec error(term()) :: {:error, term()}
  def error(term), do: {:error, term}

  @doc """
  Wraps a term in a :noreply tuple

  ## Examples

      iex> %{} |> Map.put(:count, 0) |> Euclid.Sugar.noreply()
      {:noreply, %{count: 0}}
  """
  @spec noreply(term()) :: {:noreply, term()}
  def noreply(term), do: {:noreply, term}

  @doc """
  Wraps a term in an :ok tuple

  ## Examples

      iex> %{} |> Map.put(:count, 10) |> Euclid.Sugar.ok()
      {:ok, %{count: 10}}
  """
  @spec ok(term()) :: {:ok, term()}
  def ok(term), do: {:ok, term}

  @doc """
  Accepts two arguments and returns the second. Useful at the end of the pipeline when you
  want to return a different value than the last result of the pipeline, such as when the
  pipeline has side effects and you want to return a different value and you feel the code
  will be easier to read if everything is in a pipeline.

  ## Examples

      iex> %{} |> Map.put(:count, 20) |> Euclid.Sugar.returning(:count_updated)
      :count_updated
  """
  @spec returning(any(), any()) :: any()
  def returning(_first, second), do: second
end
