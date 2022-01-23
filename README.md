# Euclid — Tools for Geometers

_Euclid_ is a collection of helper utility modules and functions.
The code is free for all to use and reuse, as a whole or piecemeal.  Specifically, if you only want a function or
two, consider copying the code to your own codebase rather than introducing Euclid as a dependency.  You don't need
to mention the source either.

## Resources

* Repo:    https://github.com/geometerio/euclid
* Docs:    https://hexdocs.pm/euclid/Euclid.html
* CI:      _Coming soon!_

## Installation

Add to `mix.exs`:

```elixir
{:euclid, "~> 0.2.5"}
```

## Upgrading

As of version `0.2.5`, the `Euclid.Extra.*` and `Euclid.Test.Extra.*` modules are deprecated.
Use the modules in `Euclid` instead (for example, `Euclid.String` instead of the deprecated `Euclid.Extra.String`).
Some other functions are deprecated too. 
See the [changelog](https://github.com/geometerio/euclid/blob/main/CHANGELOG.md#v025) for details.
Deprecated functions and modules will be removed in the upcoming `1.0` release.

## Development (of Euclid itself)

### Getting started

After cloning this repo, run `bin/dev/doctor`. If it finds a problem, it will *suggest* a remedy,
which it will put in the clipboard. If you think the remedy will work well on your computer, paste it into
your terminal. You can also try a different remedy -- `doctor` is not omnipotent. Then run `doctor` over 
and over until it succeeds. (Note: `doctor` may not work well on Windows.)

### Day to day development

1. Get new commits with `bin/dev/update`.
1. Make changes and run `bin/dev/test` to make sure everything works. Please add new tests for new functionality.
1. Run `bin/dev/shipit` when you're ready to ship.

### Running a local version of Euclid in a local version of your application

```elixir
# In YOUR APPLICATION's mix.exs:
def deps do
  [
    local_or_remote(:remote, :euclid, version: "~> 0.2", path: "../euclid")
  ]
end

defp local_or_remote(:local, package, options) do
  {package, options |> Keyword.delete(:organization) |> Keyword.delete(:version)}
end

defp local_or_remote(:remote, package, options) do
  {package, options |> Keyword.get(:version), options |> Keyword.delete(:path) |> Keyword.delete(:version)}
end
```

### Publishing a new version of Euclid

1. Increment the version (in `VERSION`) following [Semantic Versioning](https://semver.org/).
1. Commit the version file and push using `bin/dev/shipit`
1. Coming soon: ~~CI will run tests, and if tests pass, it will publish a new patch version in Hex.~~
1. Publish the new Hex package version: `mix hex.publish package` (include `package` to avoid publishing the docs,
    which are still too ugly to publish).
1. Once the new version is published:
    * Change `:local` back to `:remote` in your application's `mix.exs` 
    * Run `mix deps.update euclid` in your application to get the latest version.

## Copyright and license

Copyright © 2020-2022 Geometer, LLC.  See also [License](https://github.com/geometerio/euclid/blob/main/LICENSE.md)

## Random

**geometer**: a specialist in geometry

**Euclid**: the father of geometry
