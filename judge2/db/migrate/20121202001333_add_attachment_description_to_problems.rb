class AddAttachmentDescriptionToProblems < ActiveRecord::Migration
  def self.up
    change_table :problems do |t|
      t.has_attached_file :pdescription
    end
    remove_column :problems, :url
  end

  def self.down
    drop_attached_file :problems, :pdescription
    change_table :problems do |t|
      t.string :url
    end
  end
end
