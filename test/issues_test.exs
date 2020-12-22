defmodule IssuesTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_descending: 1]

  test ":help returned by option parsing with -h and --help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 5}
  end

  test "sort descending order the correct way" do
    result = sort_descending(fake_list(["c", "b", "a"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{c b a}
  end

  defp fake_list(values) do
    for value <- values, do: %{"created_at" => value, "other" => "xxx"}
  end
end
