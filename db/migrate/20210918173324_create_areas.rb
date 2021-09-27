class CreateAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :areas do |t|
      t.string :name
      t.string :en_name
      t.timestamps null: false
    end
  end
end
