class CreateCreatureKillCreditBindings < ActiveRecord::Migration
  def change
    create_table :creature_kill_credit_bindings do |t|
      t.integer   :creature_id,           null: false
      t.integer   :kill_credit_eid,       null: false
      t.integer   :index,                 null: false
    end
  end
end
