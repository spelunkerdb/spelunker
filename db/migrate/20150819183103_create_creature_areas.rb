class CreateCreatureAreas < ActiveRecord::Migration
  def change
    create_table :creature_areas do |t|
      t.integer     :target_id,     null: false
      t.integer     :creature_eid,  null: false
      t.integer     :area_eid,      null: false
    end

    add_index :creature_areas, [:target_id, :creature_eid, :area_eid], name: 'idx_creature_areas_uniq', unique: true
  end
end
