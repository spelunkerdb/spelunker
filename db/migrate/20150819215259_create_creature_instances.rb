class CreateCreatureInstances < ActiveRecord::Migration
  def change
    create_table :creature_instances do |t|
      t.integer     :target_id,             null: false
      t.integer     :creature_eid,          null: false
      t.decimal     :guid,                  null: false, precision: 39, scale: 0

      t.integer     :map_eid,               null: false

      t.integer     :character_class_eid,   null: true, default: nil
      t.integer     :gender_eid,            null: true, default: nil
      t.integer     :faction_eid,           null: true, default: nil
      t.integer     :power_type_eid,        null: true, default: nil

      t.integer     :level,                 null: true, default: nil
      t.integer     :effective_level,       null: true, default: nil
      t.integer     :maximum_health,        null: true, default: nil
      t.integer     :maximum_power,         null: true, default: nil

      t.integer     :base_attack_time,      null: true, default: nil
      t.integer     :ranged_attack_time,    null: true, default: nil
    end

    add_index :creature_instances, :guid, name: 'idx_creature_instances_uniq', unique: true
  end
end
