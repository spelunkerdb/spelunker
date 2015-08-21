class CreateContinents < ActiveRecord::Migration
  def change
    create_table :continents do |t|
      t.integer   :target_id,                 null: false

      t.integer   :map_eid,                   null: true

      t.string    :name,                      null: false
      t.string    :slug,                      null: false
    end
  end
end
