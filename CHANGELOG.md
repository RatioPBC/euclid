# Changelog

## v0.2.5

### Deprecations
- Deprecated all modules in `Euclid.Extra` and `Euclid.Test.Extra`. They are now at the top level.
  For example, `Euclid.Extra.String` is now just `Euclid.String`.
- Deprecated `Euclid.Assertions.assert_datetime_approximate` in favor of `Euclid.Assertions.assert_eq` with the `:within` option.
  For example, instead of `assert_datetime_approximate(dt1, dt2, 30)`, use `assert_eq(dt1, dt2, within: {30, :second})`.

Deprecated modules and functions will be removed in the `1.0` release.

### Additions and changes
- Added `Euclid.File` which has `new_tempfile_path/1` and `write_tempfile/2` functions.
- Added `Euclid.Difference` protocol which has a `diff/2` function. The default implementation does a simple
  subtraction with `Kernel.-/2`, and also includes implementations for `DateTime`, `NaiveDateTime`, and `BitString` (strings).
- Added `Euclid.Duration` which is a `{time, unit}` tuple (for example, `{200, :millisecond}`). 
  It has `convert/2` and `to_string/1` functions.
- Added `Euclid.Sugar` which has some handy functions meant to be imported.
- `Euclid.Random.string` now supports base32 encoding. The default is still base64. 
  Base32 is useful for file names since it only contains letters and numbers.
- `Euclid.Assertions.assert_eq` now supports `:within` option. It uses `Euclid.Difference` to determine whether the two
  values are within the given delta. It also supports `Duration`s so it can check whether two `DateTime`s are within
  some delta. Examples: `assert_eq(temp, 98.6, within: 1.5)`, `assert_eq(created_at, now(), within: {5, :second})`.
- Added `Euclid.DateTime.parse_iso8601/1` which is like `DateTime.parse_iso8601/1` but raises if the string is not
  in ISO8601 format.
- The `bin/dev/shipit` script (used when developing Euclid itself) now runs Dialyzer and Credo. 

## v0.2.4

- Euclid.Test.Extra.Assertions.assert_recent accepts a DateTime as a string, in ISO8601 format

## v0.2.2

- Fix deprecation warning
- Extra.Map.deep_atomize_keys, when confronted with a map entry whose value is a list of maps, will deeply atomize those maps' keys.

## v0.2.0

- Add `Euclid.Test.Helpers.Retry`
- Update readme with information about `bin/dev/doctor`

## v0.1.0

- Initial release
