class CreateExerciseProblems < ActiveRecord::Migration
  def change
    create_table :exercise_problems do |t|
      t.integer :problem_number
      t.integer :time_limit
      t.integer :score
      t.references :exercise
      t.references :problem
      t.integer :mem_lim
      t.integer :stype
      t.integer :prog_limit

      t.timestamps
    end
    add_index :exercise_problems, :exercise_id
    add_index :exercise_problems, :problem_id
  end
end
