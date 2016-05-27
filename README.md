# Druuid [![Build Status](https://travis-ci.org/bhelx/druuid.svg?branch=master)](https://travis-ci.org/bhelx/druuid) [![Hex pm](http://img.shields.io/hexpm/v/druuid.svg?style=flat)](https://hex.pm/packages/druuid)

Druuid is a Date-relative (and relatively universally unique) UUID generator. It's based on
[Recurly's UUID generator](https://github.com/recurly/druuid) which is based on Instagram's snowflake.
To understand the properties and the reasons why you'd want to use this, see
[Recurly's README](https://github.com/recurly/druuid/blob/master/README.markdown).

## Documentation

You can find documentation on [Hexdocs](https://hexdocs.pm/druuid/Druuid.html)

## Disclaimer

This library is not quite ready for production. Use at your own peril.

## Installation

This library is available as a [package on hex](https://hex.pm/packages/druuid). Just add
as a depedency to your `mix.exs`:

```elixir
  def deps do
    [{:druuid, "~> 0.2"}]
  end
```
