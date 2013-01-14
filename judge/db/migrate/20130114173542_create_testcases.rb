class CreateTestcases < ActiveRecord::Migration
  def change
    create_table :testcases do |t|
      t.references :problem
      t.integer :jtype
      t.has_attached_file :infile
      t.has_attached_file :outfile

      t.timestamps
    end
    add_index :testcases, :problem_id
  end
end
