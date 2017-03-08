class CreateRidemetrics < ActiveRecord::Migration
  def change
    create_table :ridemetrics do |t|
      t.float :start_lat
      t.float :start_long
      t.float :end_lat
      t.float :end_long

      t.timestamps null: false
    end
  end
end
