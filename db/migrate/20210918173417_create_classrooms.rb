class CreateClassrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :classrooms do |t|
      t.integer :area_id
      t.integer :place_id
      t.integer :schedule_id
      t.timestamps null: false
    end
  end
end
