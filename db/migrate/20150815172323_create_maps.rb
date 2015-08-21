class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.integer   :target_id,               null: false

      t.integer   :eid,                     null: false

      t.integer   :map_type_eid
      t.integer   :area_eid
      t.integer   :parent_map_eid
      t.integer   :expansion_eid

      t.string    :name
      t.string    :directory
      t.integer   :flags,                   limit: 8
      t.string    :horde_description
      t.string    :alliance_description

      t.integer   :max_players

      t.boolean   :tiled,                   null: false, default: false
      t.boolean   :continent,               null: false, default: false
    end

    add_index :maps, [:target_id, :eid], name: 'idx_maps_uniq', unique: true
  end
end
