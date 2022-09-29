defmodule CEvalApiWeb.Router do
  use CEvalApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", CEvalApiWeb do
    pipe_through :api

    post "/exam", ExamController, :create
    get "/exam/:code", ExamController, :show
    post "/exam/:code/answer", ExamController, :answer
    post "/exam/:code/income", ExamController, :income
    post "/exam/:code/expenses", ExamController, :expenses
    post "/exam/:code/calculate", ExamController, :calculate_credit
  end
end
