class AddReferencesToSubmission < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.remove :tcaseId
      t.references :user
      t.references :testcase
    end
  end
end
