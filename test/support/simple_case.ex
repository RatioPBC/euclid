defmodule Euclid.SimpleCase do
  @moduledoc "A basic test case"

  use ExUnit.CaseTemplate

  using do
    quote do
      import Euclid.Assertions
      import ExUnit.Assertions

      alias Euclid.Test
    end
  end
end
