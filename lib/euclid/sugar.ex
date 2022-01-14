defmodule Euclid.Sugar do
  @moduledoc "Some common syntactic sugar functions, probably best used by importing the whole module"

  @doc """
  Wraps a term in an :error tuple

  ## Examples

      socket |> assign(name: "alice") |> error()

  """
  @spec error(term()) :: {:error, term()}
  def error(term), do: {:error, term}

  @doc """
  Wraps a term in a :noreply tuple

  ## Examples

      socket |> assign(name: "alice") |> noreply()

  """
  @spec noreply(term()) :: {:noreply, term()}
  def noreply(term), do: {:noreply, term}

  @doc """
  Wraps a term in an :ok tuple

  ## Examples

      socket |> assign(name: "alice") |> ok()

  """
  @spec ok(term()) :: {:ok, term()}
  def ok(term), do: {:ok, term}

  @doc """
  Accepts two arguments and returns the second. Useful at the end of the pipeline when you
  want to return a different value than the last result of the pipeline, such as when the
  pipeline has side effects and you want to return a different value and you feel the code
  will be easier to read if everything is in a pipeline.

  ## Examples

      "/tmp/hello.txt"
      |> File.open()!
      |> File.write("hello")
      |> returning(:written)

  """
  @spec returning(any(), any()) :: any()
  def returning(_first, second), do: second
end
