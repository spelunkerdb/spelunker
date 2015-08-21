class CreateMapTypes < ActiveRecord::Migration
  def change
    create_table :map_types do |t|
      t.integer   :target_id,         null: false

      t.integer   :eid,               null: false

      t.string    :value,             null: false
      t.string    :slug,              null: false
      t.string    :label,             null: false
    end

    add_index :map_types, [:target_id, :eid], name: 'idx_map_types_uniq', unique: true
  end
end
