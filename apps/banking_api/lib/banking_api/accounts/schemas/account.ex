defmodule BankingApi.Accounts.Schemas.Account do
  @moduledoc """
  Account's schema module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:user]
  @optional_params [:balance]

  schema "accounts" do
    field :user, :string
    field :balance, :integer, default: 1000

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> unique_constraint(:user)
  end
end
