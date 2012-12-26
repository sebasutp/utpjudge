class CreateTestcases < ActiveRecord::Migration
  def change
    create_table :testcases do |t|
      t.references :problem
      t.integer :jtype

      t.timestamps
    end
    add_index :testcases, :problem_id
  end
end
