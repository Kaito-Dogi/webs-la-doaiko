class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :token_key
      t.string :name
      t.string :nickname
      t.string :email
      t.integer :term
      t.string :image_url
      t.string :default_image_url
      t.integer :area_id
      # t.string :password_digest
      t.timestamps null: false
    end
  end
end
