# Euclid — Tools for Geometers

_Euclid_ is a grab-bag of code that we use and reuse in Elixir projects. Parts of it are inspired by functionality
in [Ruby](https://www.ruby-lang.org/en/) and/or
[ActiveSupport](https://guides.rubyonrails.org/active_support_core_extensions.html). Other functions or snippets
are here because we ([unlike some others](https://groups.google.com/g/elixir-lang-core/c/6MKPhY451Ng)) believe that
giving names to common concepts is a good thing.

The code is free for all to use and reuse, as a whole or piecemeal.  Specifically, if you only want a function or
two, consider copying the code to your own codebase rather than introducing Euclid as a dependency.  You don't need
to mention the source either.

## Resources

* Repo:    https://github.com/geometerio/euclid
* CI:      _Coming soon!_

## Installation

_Euclid_ can be installed like a normal Hex package, but for internal development, we recommend this more elaborate
method:

```elixir
# In mix.exs
def deps do
  [
    local_or_remote(:remote, :euclid, version: "~> 1.0", path: "../euclid")
  ]
end

defp local_or_remote(:local, package, options) do
  {package, options |> Keyword.delete(:organization) |> Keyword.delete(:version)}
end

defp local_or_remote(:remote, package, options) do
  {package, options |> Keyword.get(:version), options |> Keyword.delete(:path) |> Keyword.delete(:version)}
end
```

## Development

### Getting started

After cloning this repo, run `bin/dev/doctor`. If it finds a problem, it will *suggest* a remedy,
which it will put in the clipboard. If you think the remedy will work well on your computer, paste it into
your terminal. You can also try a different remedy -- `doctor` is not omnipotent. Then run `doctor` over 
and over until it succeeds. (Note: `doctor` may not work well on Windows.)

### Making changes

If you have write access to this repo, this is how you add features (or fix bugs):

1. In the deps section `mix.exs` in your application, change `:remote` to `:local`.
1. Edit Euclid code locally.
1. Run tests with `bin/dev/test`.
1. Once you're happy with your changes, perform the traditional dance of commit, fetch and rebase.
1. Increment the version (in `VERSION`) following [Semantic Versioning](https://semver.org/).
1. Commit the version file and push using `bin/dev/shipit`
1. Coming soon: ~~CI will run tests, and if tests pass, it will publish a new patch version in Hex.~~
1. Publish the new Hex package version: `mix hex.publish package` (include `package` to avoid publishing the docs,
    which are still too ugly to publish).
1. Once the new version is published:
    * Change `:local` back to `:remote` in your application's `mix.exs` 
    * Run `mix deps.update euclid` in your application to get the latest version.

Please note that while we appreciate bug fixes and documentation patches, we will only add or change features based
on our internal needs.

## Copyright and license

Copyright © 2020 Geometer, LLC.  See also [License](LICENSE.md)

## Random

**geometer**: a specialist in geometry

**Euclid**: the father of geometry