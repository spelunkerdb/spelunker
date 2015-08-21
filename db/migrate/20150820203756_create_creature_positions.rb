class CreateCreaturePositions < ActiveRecord::Migration
  def change
    create_table :creature_positions do |t|
      t.integer     :target_id,     null: false
      t.integer     :creature_eid,  null: false
      t.integer     :map_eid,       null: false

      t.float       :position_x,    null: false
      t.float       :position_y,    null: false
      t.float       :position_z,    null: false
    end
  end
end
