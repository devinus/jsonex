defmodule JSON.Mixfile do
  use Mix.Project

  @version String.strip(File.read!("VERSION"))

  def project do
    [ app: :jsonex,
      version: @version,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [ { :jsx, git: "git://github.com/talentdeficit/jsx.git", compile: "rebar compile" } ]
  end
end
