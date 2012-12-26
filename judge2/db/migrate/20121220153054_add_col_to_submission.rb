class AddColToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :tcaseId, :integer
  end
end
