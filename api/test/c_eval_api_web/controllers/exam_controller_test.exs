defmodule CEvalApiWeb.ExamControllerTest do
  use CEvalApiWeb.ConnCase

  import Mock
  import CEvalApi.ExamsFixtures

  alias CEvalApi.Exams.Exam

  setup %{conn: conn} do

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create exam" do
    test "renders exam when data is valid", %{conn: conn} do
      conn = post(conn, Routes.exam_path(conn, :create))
      assert %{"id" => id, "code" => code} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.exam_path(conn, :show, code))

      assert %{
               "id" => ^id,
               "code" => ^code,
               "expenses" => nil,
               "income" => nil,
               "initial_questions" => [],
               "score" => nil
             } = json_response(conn, 200)["data"]
    end
  end

  describe "update exam" do
    setup [:create_exam]

    test "renders exam when data is valid", %{conn: conn, exam: %Exam{id: id, code: code} = exam} do
      conn = post(conn, Routes.exam_path(conn, :answer, exam.code), answer: true)
      assert %{"id" => ^id, "code" => ^code} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.exam_path(conn, :show, exam.code))

      assert %{
               "id" => ^id,
               "code" => ^code,
               "initial_questions" => [true, true, true, true, true]
             } = json_response(conn, 200)["data"]
    end
  end

  describe "update exam full" do
    setup [:create_exam_full]

    test "renders errors when the questions are filled", %{conn: conn, exam: exam} do
      conn = post(conn, Routes.exam_path(conn, :answer, exam.code), answer: true)
      assert json_response(conn, 409) == %{"errors" => %{"detail" => "Conflict"}}
    end

    test "update the income", %{conn: conn, exam: exam} do
      conn = post(conn, Routes.exam_path(conn, :income, exam.code), amount: 2000)

      assert %{
               "income" => 2000,
               "score" => 11
             } = json_response(conn, 200)["data"]
    end

    test "update the expenses", %{conn: conn, exam: exam} do
      conn = post(conn, Routes.exam_path(conn, :expenses, exam.code), amount: 1000)

      assert %{
               "expenses" => 1000,
               "score" => 11
             } = json_response(conn, 200)["data"]
    end

    test "calculates the credit with error", %{conn: conn, exam: exam} do
      conn_1 = post(conn, Routes.exam_path(conn, :income, exam.code), amount: 2000)
      assert %{
               "income" => 2000,
               "score" => 11
             } = json_response(conn_1, 200)["data"]

      conn_2 = post(conn, Routes.exam_path(conn, :expenses, exam.code), amount: 3000)
      assert %{
               "expenses" => 3000,
               "score" => 11
             } = json_response(conn_2, 200)["data"]

      conn = post(conn, Routes.exam_path(conn, :calculate_credit, exam.code))
      assert json_response(conn, 409) == %{"errors" => %{"detail" => "Conflict"}}
    end

    test "calculates the credit with more expenses", %{conn: conn, exam: exam} do
      conn = post(conn, Routes.exam_path(conn, :calculate_credit, exam.code))

      assert json_response(conn, 409) == %{"errors" => %{"detail" => "Conflict"}}
    end
  end

  describe "update exam prepared" do
    setup [:create_exam_prepared]

    test "calculates the credit", %{conn: conn, exam: exam} do
      with_mocks([{HTTPoison, [], [get!: fn
        "https://lxzau4xjot.api.quickmocker.com/creditScore/11" -> %{status: 200, body: "{\"creditScore\":100}"}
        end
      ]}]) do
        conn = post(conn, Routes.exam_path(conn, :calculate_credit, exam.code))

        assert %{
                 "exam" => %{
                   "income" => 6000,
                   "expenses" => 3000,
                   "score" => 11
                 },
                 "credit_amount" => 36000,
                 "credit_score" => 100
               } = json_response(conn, 200)["data"]
      end
    end
  end

  defp create_exam(_) do
    exam = exam_fixture(%{initial_questions: [true, true, true, true]})
    %{exam: exam}
  end

  defp create_exam_full(_) do
    exam = exam_fixture(%{initial_questions: [true, true, true, true, true]})
    %{exam: exam}
  end

  defp create_exam_prepared(_) do
    exam = exam_fixture(%{initial_questions: [true, true, true, true, true], income: 6000, expenses: 3000})
    %{exam: exam}
  end
end
