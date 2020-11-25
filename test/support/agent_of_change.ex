defmodule AgentOfChange do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def get(), do: Agent.get(__MODULE__, fn state -> state end)

  def add() do
    value =
      Agent.get_and_update(__MODULE__, fn value ->
        value = value + 1
        {value, value}
      end)

    {:ok, value}
  end
end
