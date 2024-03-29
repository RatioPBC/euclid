defmodule Euclid.FileTest do
  use Euclid.SimpleCase, async: true

  describe "new_tempfile_path" do
    test "generates a tempfile path" do
      ".txt"
      |> Euclid.File.new_tempfile_path()
      |> Path.split()
      |> List.last()
      |> assert_eq(~r|^[A-Z2-7]{10}.txt$|)
    end
  end

  describe "write_tempfile" do
    test "writes text to a tempfile with the given extension" do
      path = Euclid.File.write_tempfile("the contents", ".txt")
      assert path =~ ~r/.txt$/
      assert File.read!(path) == "the contents"
    end
  end
end
