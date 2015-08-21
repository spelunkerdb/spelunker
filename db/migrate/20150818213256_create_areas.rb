class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.integer   :target_id,               null: false

      t.integer   :zone_id,                 null: true
      t.integer   :city_id,                 null: true
      t.integer   :dungeon_id,              null: true
      t.integer   :raid_id,                 null: true
      t.integer   :scenario_id,             null: true
      t.integer   :battleground_id,         null: true
      t.integer   :arena_id,                null: true

      t.integer   :eid,                     null: false

      t.integer   :map_eid
      t.integer   :parent_area_eid

      t.string    :name
      t.string    :internal_name
      t.integer   :flags_1,                 limit: 8
      t.integer   :flags_2,                 limit: 8
    end

    add_index :areas, [:target_id, :eid], name: 'idx_areas_uniq', unique: true
  end
end
