class CreateCreatures < ActiveRecord::Migration
  def change
    create_table :creatures do |t|
      t.integer     :target_id,             null: false
      t.integer     :build_number,          null: false
      t.integer     :eid,                   null: false

      t.integer     :character_class_eid,   null: true, default: nil
      t.integer     :faction_eid,           null: true, default: nil
      t.integer     :power_type_eid,        null: true, default: nil

      t.integer     :expansion_eid,         null: true, default: nil
      t.integer     :creature_movement_info_eid, null: true, default: nil
      t.integer     :creature_family_eid,   null: true, default: nil
      t.integer     :creature_type_eid,     null: true, default: nil
      t.integer     :creature_rank_eid,     null: true, default: nil

      t.string      :name,                  null: true, default: nil
      t.string      :female_name,           null: true, default: nil
      t.string      :title,                 null: true, default: nil
      t.string      :female_title,          null: true, default: nil
      t.string      :cursor_name,           null: true, default: nil

      t.float       :health_multiplier,     null: true, default: nil
      t.float       :power_multiplier,      null: true, default: nil

      t.boolean     :racial_leader,         null: true, default: nil

      t.integer     :flags_1,               null: true, default: nil, limit: 8
      t.integer     :flags_2,               null: true, default: nil, limit: 8
      t.integer     :quest_flags,           null: true, default: nil, limit: 8
    end

    add_index :creatures, [:target_id, :eid], name: 'idx_creatures_uniq', unique: true
  end
end
