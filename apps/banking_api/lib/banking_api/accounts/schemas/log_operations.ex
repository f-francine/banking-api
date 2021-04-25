defmodule BankingApi.Accounts.Schemas.LogOperations do
  @moduledoc """
  Log operations' schema module
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias BankingApi.Accounts.Schemas.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:from_account_id, :value, :operation_type]
  @optional_params [:to_account_id]

  schema "log_operations" do
    field :value, :integer
    field :operation_type, :string
    belongs_to :from_account, Account
    belongs_to :to_account, Account

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
  end
end
