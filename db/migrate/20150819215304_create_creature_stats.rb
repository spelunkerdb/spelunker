class CreateCreatureStats < ActiveRecord::Migration
  def change
    create_table :creature_stats do |t|
      t.integer     :target_id,         null: false
      t.integer     :creature_eid,      null: false

      t.integer     :minimum_level,     null: true, default: nil
      t.integer     :maximum_level,     null: true, default: nil
      t.integer     :average_level,     null: true, default: nil

      t.integer     :minimum_health,    null: true, default: nil
      t.integer     :maximum_health,    null: true, default: nil
      t.integer     :average_health,    null: true, default: nil

      t.integer     :minimum_power,     null: true, default: nil
      t.integer     :maximum_power,     null: true, default: nil
      t.integer     :average_power,     null: true, default: nil
    end

    add_index :creature_stats, [:target_id, :creature_eid], name: 'idx_creature_stats_uniq', unique: true
  end
end
