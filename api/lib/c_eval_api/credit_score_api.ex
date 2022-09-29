defmodule CEvalApi.CreditScoreApi do

  @endpoint "https://lxzau4xjot.api.quickmocker.com/creditScore"

  def get_credit_score(score) do
    "#{@endpoint}/#{score}"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("creditScore")
  rescue
    _ -> nil
  end

end