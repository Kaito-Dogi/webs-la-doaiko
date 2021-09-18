class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :official_name
      t.string :popular_name
      t.string :lowercase_name
      t.timestamps null: false
    end
  end
end
