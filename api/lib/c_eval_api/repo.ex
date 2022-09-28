defmodule CEvalApi.Repo do
  use Ecto.Repo,
    otp_app: :c_eval_api,
    adapter: Ecto.Adapters.Postgres
end
