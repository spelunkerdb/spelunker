class CreateClientBuilds < ActiveRecord::Migration
  def change
    create_table :client_builds do |t|
      t.integer   :client_era_id,     null: false
      t.integer   :client_version_id, null: false
      t.integer   :client_patch_id,   null: false
      t.string    :slug,              null: false
      t.integer   :number,            null: false
      t.string    :archive_type,      null: false
      t.date      :released_on,       null: false
      t.boolean   :supported,         null: false
    end
  end
end
