class CreateExcerciseProblems < ActiveRecord::Migration
  def change
    create_table :excercise_problems do |t|
      t.integer :problem_number
      t.integer :time_limit
      t.integer :score
      t.references :excercise
      t.references :problem

      t.timestamps
    end
    add_index :excercise_problems, :excercise_id
    add_index :excercise_problems, :problem_id
  end
end
