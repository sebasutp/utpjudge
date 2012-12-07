class AddMlExPro < ActiveRecord::Migration
  def up
      add_column :excercise_problems, :mem_lim, :integer
      add_column :excercise_problems, :stype, :integer
      add_column :excercise_problems, :prog_limit, :integer
  end

  def down
      remove_column :excercise_problems, :mem_lim
      remove_column :excercise_problems, :stype
      remove_column :excercise_problems, :prog_limit
  end
end
