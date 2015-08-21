class CreateTargetAggregates < ActiveRecord::Migration
  def change
    create_table :target_aggregates do |t|
      t.integer   :target_id,             null: false
      t.integer   :aggregated_target_id,  null: false
    end
  end
end
