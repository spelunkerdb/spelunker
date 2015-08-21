class CreateTerritoryFactions < ActiveRecord::Migration
  def change
    create_table :territory_factions do |t|
      t.string    :name,      null: false
      t.string    :slug,      null: false
    end
  end
end
