class CreateMapChunks < ActiveRecord::Migration
  def change
    create_table :map_chunks do |t|
      t.integer   :map_id,        null: false
      t.integer   :map_tile_id,   null: false

      t.integer   :area_eid

      t.integer   :tile_x,        null: false
      t.integer   :tile_y,        null: false
      t.integer   :chunk_x,       null: false
      t.integer   :chunk_y,       null: false

      t.integer   :flags,         limit: 8

      t.float     :position_x
      t.float     :position_y
      t.float     :position_z
    end

    #add_index :map_chunks, :map_tile_id
    #add_index :map_chunks, :map_id
    #add_index :map_chunks, [:map_tile_id, :chunk_x, :chunk_y], name: 'idx_map_chunks_uniq', unique: true
  end
end
