defmodule Euclid.Extra.StringTest do
  use Euclid.SimpleCase, async: true

  import Euclid.Extra.String

  describe "dasherize" do
    test "replaces non-string characters with dashes" do
      assert dasherize(" A brown cow.") == "a-brown-cow"
      assert dasherize("SomeModule.Name") == "some-module-name"
    end

    test "stringifies atoms" do
      assert dasherize(:ok) == "ok"
    end
  end

  describe "inner_truncate" do
    test "works with nil" do
      assert inner_truncate(nil, 10) == nil
    end

    test "doesn't change short strings" do
      assert inner_truncate("12345", 10) == "12345"
      assert inner_truncate("12345", 5) == "12345"
    end

    test "removes the middle of long strings" do
      assert inner_truncate("1234567890", 4) == "12…90"
      assert inner_truncate("1234567890", 5) == "123…90"
      assert inner_truncate("1234567890", 6) == "123…890"
    end
  end

  describe "squish" do
    test "removes whitespace" do
      assert " foo  BAR  \t baz \n FEz    " |> squish() == "foo BAR baz FEz"
    end

    test "allows nil", do: nil |> squish() |> assert_eq(nil)
  end

  describe "to_integer" do
    test "doesn't blow up on nil" do
      assert to_integer(nil) == nil
    end

    test "converts to integer" do
      assert to_integer("12345") == 12345
    end

    test "allows commas and spaces" do
      assert to_integer(" 12,345  ") == 12345
    end

    test "can be very lenient" do
      assert to_integer("  12,3m 456,,@789   ", :lenient) == 123_456_789
    end

    test "can default" do
      assert to_integer(nil, default: 4) == 4
      assert to_integer("", default: 4) == 4
      assert to_integer("100", default: 4) == 100
    end
  end

  describe "trim" do
    test "doesn't blow up on nil" do
      assert trim(nil) == nil
    end

    test "trims from left and right" do
      assert trim("  foo  ") == "foo"
    end
  end

  describe "truncate_at" do
    test "truncates at the last instance of 'at' that doesn't exceed the limit" do
      "12345. 12345. 12345."
      |> truncate_at(".", 16)
      |> assert_eq("12345. 12345.")
    end

    test "doesn't truncate if it does not exceed the limit" do
      "12345. 12345."
      |> truncate_at(".", 999)
      |> assert_eq("12345. 12345.")
    end

    test "truncates at the limit if 'at' is not in the string" do
      "1234567890"
      |> truncate_at(".", 5)
      |> assert_eq("12345")
    end

    test "truncates at the limit if 'at' is not in within the limit" do
      "12345678.90"
      |> truncate_at(".", 5)
      |> assert_eq("12345")
    end

    test "doesn't mess with the content" do
      "aaaaaaaaaaaaa"
      |> truncate_at("a", 3)
      |> assert_eq("aaa")
    end
  end

  describe "underscore" do
    test "replaces non-string characters with dashes" do
      assert underscore(" A brown - cow.") == "a_brown_cow"
      assert underscore("SomeModule.Name") == "some_module_name"
    end

    test "stringifies atoms" do
      assert underscore(:ok) == "ok"
    end
  end

  describe "secure_compare/2" do
    test "compares binaries securely" do
      assert secure_compare(<<>>, <<>>)
      assert secure_compare(<<0>>, <<0>>)

      refute secure_compare(<<>>, <<1>>)
      refute secure_compare(<<1>>, <<>>)
      refute secure_compare(<<0>>, <<1>>)

      assert secure_compare("test", "test")
      assert secure_compare("無", "無")
      refute secure_compare(nil, nil)
      refute secure_compare(nil, "")
      refute secure_compare("", nil)
      refute secure_compare('', nil)
    end
  end
end
