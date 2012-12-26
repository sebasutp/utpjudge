class CreateExcercises < ActiveRecord::Migration
  def change
    create_table :excercises do |t|
      t.string :name
      t.datetime :from_date
      t.datetime :to_date

      t.timestamps
    end
  end
end
