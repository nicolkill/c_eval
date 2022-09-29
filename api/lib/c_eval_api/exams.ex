defmodule CEvalApi.Exams do
  @moduledoc """
  The Exams context.
  """

  import Ecto.Query, warn: false

  alias CEvalApi.Repo
  alias CEvalApi.Exams.Exam

  use Exam

  def get_exam!(code), do: Exam |> where(code: ^code) |> Repo.one()

  def create_exam(attrs \\ %{}) do
    %Exam{}
    |> Exam.changeset(attrs)
    |> Repo.insert()
  end

  def update_exam(%Exam{} = exam, attrs) do
    exam
    |> Exam.changeset(attrs)
    |> Repo.update()
  end

  def calculate_score(%Exam{initial_questions: questions}) when length(questions) == @questions_count do
    questions
    |> Enum.with_index()
    |> Enum.reduce(0, fn
      {true, 0}, acc -> 4 + acc
      {true, 3}, acc -> 1 + acc
      {true, index}, acc when index in [1, 2, 4] -> 2 + acc
      _, acc -> acc
    end)
    |> (&({:ok, &1})).()
  end
  def calculate_score(_), do: {:error, nil}


  def calculate_credit_amount(%Exam{income: income, expenses: expenses}) when income > expenses,
       do: {:ok, (income - expenses) * 12}
  def calculate_credit_amount(_), do: {:error, nil}

end
