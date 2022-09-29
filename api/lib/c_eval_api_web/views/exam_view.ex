defmodule CEvalApiWeb.ExamView do
  use CEvalApiWeb, :view

  alias CEvalApi.Exams
  alias CEvalApiWeb.ExamView

  def render("index.json", %{exams: exams}) do
    %{data: render_many(exams, ExamView, "exam.json")}
  end

  def render("show.json", %{exam: exam}) do
    %{data: render_one(exam, ExamView, "exam.json")}
  end

  def render("exam.json", %{exam: exam}) do
    {_, score} = Exams.calculate_score(exam)
    %{
      id: exam.id,
      code: exam.code,
      initial_questions: exam.initial_questions,
      income: exam.income,
      expenses: exam.expenses,
      score: score,
      updated_at: exam.updated_at,
      inserted_at: exam.inserted_at
    }
  end

  def render("credit.json", %{exam: exam, credit_amount: credit_amount, credit_score: credit_score}) do
    %{
      data: %{
        exam: render_one(exam, ExamView, "exam.json"),
        credit_amount: credit_amount,
        credit_score: credit_score
      }
    }
  end
end
