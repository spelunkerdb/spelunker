class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.string    :slug,                null: false
      t.string    :level,               null: false
      t.integer   :current_target_id,   null: true, default: nil
    end

    add_index :targets, :slug, name: 'idx_targets_uniq', unique: true
  end
end
