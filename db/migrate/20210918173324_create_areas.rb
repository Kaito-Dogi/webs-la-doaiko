class CreateAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :areas do |t|
      t.string :name
      t.string :lowercase_name
      t.timestamps null: false
    end
  end
end
