defmodule CEvalApi.Repo.Migrations.CreateExams do
  use Ecto.Migration

  def change do
    create table(:exams) do
      add :code, :string
      add :initial_questions, {:array, :boolean}, default: []
      add :income, :integer, null: true
      add :expenses, :integer, null: true

      timestamps()
    end
  end
end
