defmodule Euclid.SimpleCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Euclid.Test.Extra.Assertions
      import ExUnit.Assertions

      alias Euclid.Test
    end
  end
end
