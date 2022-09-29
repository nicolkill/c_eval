defmodule CEvalApiWeb.ExamController do
  use CEvalApiWeb, :controller

  alias CEvalApi.Exams
  alias CEvalApi.Exams.Exam
  alias CEvalApi.CreditScoreApi

  use Exam

  action_fallback CEvalApiWeb.FallbackController

  def create(conn, _) do
    with {:ok, %Exam{} = exam} <- Exams.create_exam() do
      conn
      |> put_status(:created)
      |> render("show.json", exam: exam)
    end
  end

  def show(conn, %{"code" => code}) do
    with exam = Exams.get_exam!(code) do
      render(conn, "show.json", exam: exam)
    end
  end

  def answer(conn, %{"code" => code, "answer" => answer}) do
    with %Exam{initial_questions: questions} = exam when length(questions) < @questions_count <- Exams.get_exam!(code),
         {:ok, %Exam{} = exam} <- Exams.update_exam(exam, %{initial_questions: questions ++ [answer]}) do
      render(conn, "show.json", exam: exam)
    end
  end

  def income(conn, %{"code" => code, "amount" => income}) do
    with %Exam{} = exam <- Exams.get_exam!(code),
         {:ok, %Exam{} = exam} <- Exams.update_exam(exam, %{income: income}) do
      render(conn, "show.json", exam: exam)
    end
  end

  def expenses(conn, %{"code" => code, "amount" => expenses}) do
    with %Exam{} = exam <- Exams.get_exam!(code),
         {:ok, %Exam{} = exam} <- Exams.update_exam(exam, %{expenses: expenses}) do
      render(conn, "show.json", exam: exam)
    end
  end

  def calculate_credit(conn, %{"code" => code}) do
    with %Exam{} = exam = Exams.get_exam!(code),
         {:ok, score} when score > @questions_count <- Exams.calculate_score(exam),
         {:ok, credit_amount} <- Exams.calculate_credit_amount(exam) do
      render(conn, "credit.json", exam: exam, credit_score: CreditScoreApi.get_credit_score(score), credit_amount: credit_amount)
    end
  end
end
