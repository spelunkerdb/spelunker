class CreateCreatureDisplayBindings < ActiveRecord::Migration
  def change
    create_table :creature_display_bindings do |t|
      t.integer   :creature_id,           null: false
      t.integer   :creature_display_eid,  null: false
      t.integer   :index,                 null: false
    end
  end
end
