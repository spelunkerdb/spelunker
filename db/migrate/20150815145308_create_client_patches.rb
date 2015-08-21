class CreateClientPatches < ActiveRecord::Migration
  def change
    create_table :client_patches do |t|
      t.integer   :client_era_id,     null: false
      t.integer   :client_version_id, null: false
      t.string    :slug,              null: false
      t.integer   :current_build_id,  null: true
    end
  end
end
