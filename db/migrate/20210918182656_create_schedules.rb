class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.string :kind
      t.string :dayOfWeek
      t.timestamps null: false
    end
  end
end
