defmodule Issues.CLI do
  @default_count 5

  @moduledoc """
  Handle the command line parsing and the dispatch of the functions
  that generate a table of the last _n_  issues in a github project
  """

  def main(argv) do
    argv
    |> parse_args()
    |> process
  end

  @doc """
  `argv` can be --help or -h, which returns :help

  Otherwise, it is a github user name, project name and optionally the number
  of entries to format.

  Return a tuple of `{user, project, count}, or :help if help was given
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts("Usage: issues <user> <project> [count | #{@default_count}]")
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_descending()
    |> last(count)
    |> Enum.map(fn it ->
      %{"number" => it["number"], "created_at" => it["created_at"], "title" => it["title"]}
    end)
    |> Jason.encode()
    |> to_json()
    |> IO.puts()
  end

  def to_json({:ok, json}) do
    json
  end

  def last(list, count) do
    list |> Enum.take(count) |> Enum.reverse()
  end

  def sort_descending(issues_list) do
    issues_list
    |> Enum.sort(fn i1, i2 -> i1["created_at"] >= i2["created_at"] end)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end
end
