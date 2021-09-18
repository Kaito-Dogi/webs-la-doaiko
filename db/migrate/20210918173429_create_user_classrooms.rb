class CreateUserClassrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :user_classrooms do |t|
      t.integer :user_id
      t.integer :classroom_id
      t.timestamps null: false
    end
  end
end
