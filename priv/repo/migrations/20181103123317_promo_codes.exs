defmodule Feather.Repo.Migrations.PromoCodes do
  use Ecto.Migration

  def up do
    create table(:promo_codes) do
      add :code, :string
      add :description, :string
      add :is_active, :boolean
      add :type, :string
      add :amount, :decimal
      add :event_id, :integer
      add :event_location, :geometry
      add :radius, :decimal
      add :expire_time, :naive_datetime
      add :activation_time, :naive_datetime
      timestamps()
    end
    create unique_index(:promo_codes, [:event_location, :code])
  end

  def down do
    drop table(:promo_codes)
  end
end


# item = %{code: "DELHI", description: "testing code", is_active: true, type: "unique", amount: 101.50, event_location: %Geo.Point{coordinates: {77.1025, 28.7041}, srid: 4326}}
# item = %{code: "KHURJA", description: "testing code", is_active: true, type: "unique", amount: 101.50, event_location: %Geo.Point{coordinates: {77.8539, 28.2514}, srid: 4326}}
# item = %{code: "MEERUT", description: "testing code", is_active: true, type: "unique", amount: 101.50, event_location: %Geo.Point{coordinates: {77.7064, 28.9845}, srid: 4326}}