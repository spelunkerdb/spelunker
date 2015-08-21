class CreateMapTiles < ActiveRecord::Migration
  def change
    create_table :map_tiles do |t|
      t.integer   :map_id,          null: false

      t.integer   :tile_x,          null: false
      t.integer   :tile_y,          null: false

      t.boolean   :extant,          null: false, default: false
      t.string    :adt_file_hash,   null: true, default: nil
    end

    #add_index :map_tiles, :map_id
    #add_index :map_tiles, [:map_id, :tile_x, :tile_y], name: 'idx_map_tiles_uniq', unique: true
  end
end
