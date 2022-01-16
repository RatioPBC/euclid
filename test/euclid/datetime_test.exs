defmodule Euclid.DateTimeTest do
  use Euclid.SimpleCase, async: true

  describe "to_iso8601" do
    test "formats with no partial seconds" do
      date = %DateTime{
        year: 2000,
        month: 2,
        day: 29,
        zone_abbr: "AMT",
        hour: 23,
        minute: 0,
        second: 7,
        microsecond: {111, 5},
        utc_offset: -14400,
        std_offset: 0,
        time_zone: "America/Manaus"
      }

      assert date |> Euclid.DateTime.to_iso8601(:rounded) == "2000-02-29T23:00:07-04:00"
    end
  end
end
