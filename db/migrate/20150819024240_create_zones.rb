class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.integer   :target_id,                 null: false

      t.integer   :continent_id,              null: false
      t.integer   :territory_faction_id,      null: true

      t.string    :name,                      null: false
      t.string    :slug,                      null: false

      t.integer   :suggested_minimum_level,   null: true, default: nil
      t.integer   :suggested_maximum_level,   null: true, default: nil

      t.integer   :map_eid,                   null: true, default: nil
      t.jsonb     :area_eids,                 null: false, default: '[]'
    end
  end
end
