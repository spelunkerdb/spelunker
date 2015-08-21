class CreateCreatureQuestItemBindings < ActiveRecord::Migration
  def change
    create_table :creature_quest_item_bindings do |t|
      t.integer   :creature_id,           null: false
      t.integer   :item_eid,              null: false
      t.integer   :index,                 null: false
    end
  end
end
