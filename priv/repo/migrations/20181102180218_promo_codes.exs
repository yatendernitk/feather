defmodule Feather.Repo.Migrations.PromoCodes do
  use Ecto.Migration

  def change do
    create table(:promo_codes) do
      add :code, :string
      add :description, :string
      add :is_active, :boolean
      add :type, :string
      add :amount, :decimal
      add :event_id, :integer
      add :event_location, :geometry
    end
  end
end
