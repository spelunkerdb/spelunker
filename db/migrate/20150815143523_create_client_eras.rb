class CreateClientEras < ActiveRecord::Migration
  def change
    create_table :client_eras do |t|
      t.string    :name,              null: false
      t.string    :subdomain,         null: false
      t.string    :slug,              null: false
      t.integer   :current_build_id,  null: true, default: nil
    end
  end
end
