defmodule BankingApi.Accounts do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:user, :balance]

  schema "accounts" do

    field :user, :string
    field :balance, :integer

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
