class CreatePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :places do |t|
      t.string :name
      t.string :lowercase_name
      t.integer :area_id
      t.timestamps null: false
    end
  end
end
