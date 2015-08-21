class CreateCreatureLevelStats < ActiveRecord::Migration
  def change
    create_table :creature_level_stats do |t|
      t.integer     :target_id,         null: false
      t.integer     :creature_eid,      null: false
      t.integer     :level,             null: false

      t.integer     :minimum_health,    null: true, default: nil
      t.integer     :maximum_health,    null: true, default: nil
      t.integer     :average_health,    null: true, default: nil

      t.integer     :minimum_power,     null: true, default: nil
      t.integer     :maximum_power,     null: true, default: nil
      t.integer     :average_power,     null: true, default: nil
    end

    add_index :creature_level_stats, [:target_id, :creature_eid, :level], name: 'idx_creature_level_stats_uniq', unique: true
  end
end
