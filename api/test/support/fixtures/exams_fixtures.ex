defmodule CEvalApi.ExamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CEvalApi.Exams` context.
  """

  @doc """
  Generate a exam.
  """
  def exam_fixture(attrs \\ %{}) do
    {:ok, exam} =
      attrs
      |> Enum.into(%{
        code: "random_code",
        expenses: nil,
        income: nil,
        initial_questions: []
      })
      |> CEvalApi.Exams.create_exam()

    exam
  end
end
