class RenameSubmissionsColumn < ActiveRecord::Migration
  def up
      rename_column :submissions, :excercise_problem_id, :exercise_problem_id
  end

  def down
      rename_column :submissions, :exercise_problem_id, :excercise_problem_id
  end
end
