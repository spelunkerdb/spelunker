class CreateCaptures < ActiveRecord::Migration
  def change
    create_table :captures do |t|
      t.integer     :target_id,             null: false

      t.integer     :packets_count,         null: true, default: nil

      t.string      :file_hash,             null: false
      t.integer     :file_size,             null: false
      t.string      :file_name,             null: false

      t.timestamps                          null: false
    end

    add_index :captures, :file_hash, unique: true
  end
end
