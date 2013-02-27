class CreateTableExercisesGroups < ActiveRecord::Migration
  def change
    create_table :exercises_groups, :id=>false do |t|
      t.integer "exercise_id"
      t.integer "group_id"
    end
  end
end
