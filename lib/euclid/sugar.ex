defmodule Euclid.Sugar do
  @moduledoc """
  Some common syntactic sugar functions.

  These functions are intended to be used by importing the functions or the whole module:

  ```
  import Euclid.Sugar, only: [noreply: 1]

  def handle_event("foo", _params, socket) do
    socket |> assign(foo: "bar") |> noreply()
  end
  ```
  """

  @doc """
  Wraps a term in an :error tuple. Useful in pipelines.

  ## Examples

      iex> %{} |> Map.put(:count, "unknown") |> Euclid.Sugar.error()
      {:error, %{count: "unknown"}}
  """
  @spec error(term()) :: {:error, term()}
  def error(term), do: {:error, term}

  @doc """
  Unwraps an :error tuple, raising if the term is not an :error tuple

  ## Examples

      iex> {:error, 1} |> Euclid.Sugar.error!()
      1
  """
  @spec error!({:error, term()}) :: term()
  def error!({:error, term}), do: term

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
  Unwraps an :ok tuple, raising if the term is not an :ok tuple

  ## Examples

      iex> {:ok, 1} |> Euclid.Sugar.ok!()
      1
  """
  @spec ok!({:ok, term()}) :: term()
  def ok!({:ok, term}), do: term

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
