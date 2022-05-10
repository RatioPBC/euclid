defmodule Euclid.Protocol do
  @doc "Returns `x` or raises if `x` does not implment `protocol`"
  @spec implements!(any(), module()) :: any()
  def implements!(x, protocol) do
    if protocol.impl_for(x) == nil,
      do: raise("Expected #{inspect(x)} to implement protocol #{inspect(protocol)}"),
      else: x
  end
end
