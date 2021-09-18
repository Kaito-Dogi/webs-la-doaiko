class CreateClassrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.string :schedule
      t.integer :integer
      t.timestamps null: false
    end
  end
end
