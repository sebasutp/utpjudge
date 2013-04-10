class Group < ActiveRecord::Base
  attr_accessible :name, :owner, :password
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :exercises
  
  validates_uniqueness_of :name
  
  def owner_name
    return User.find(owner).name
  end
  
end
