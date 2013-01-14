class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.datetime :from_date
      t.datetime :to_date

      t.timestamps
    end
  end
end
