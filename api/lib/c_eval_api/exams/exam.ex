defmodule CEvalApi.Exams.Exam do
  use Ecto.Schema

  import Ecto.Changeset

  @attrs [:initial_questions, :income, :expenses]

  schema "exams" do
    field :code, :string, autogenerate: {__MODULE__, :generate_code, []}
    field :expenses, :integer
    field :income, :integer
    field :initial_questions, {:array, :boolean}, default: []

    timestamps()
  end

  @doc false
  def changeset(exam, attrs) do
    cast(exam, attrs, @attrs)
  end

  def generate_code,
      do:
        make_ref()
        |> :erlang.ref_to_list()
        |> List.to_string()
        |> String.replace("#Ref<", "")
        |> String.replace(">", "")
        |> String.replace(".", "")
        |> String.codepoints()
        |> Enum.chunk_every(8)
        |> Enum.join("-")

  defmacro __using__(_) do
    quote do
      @approval_score 6
      def approval_score, do: @approval_score
      @questions_count 5
      defmacro questions_count, do: @questions_count
    end
  end

end
