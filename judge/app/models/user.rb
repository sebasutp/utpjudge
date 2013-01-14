class User < ActiveRecord::Base
  attr_accessible :code, :email, :encrypted_password, :name
  has_many :submissions
  has_and_belongs_to_many :roles

  def after_create
    r = Role.find(3)
    self.roles << r
  end

  def has_roles(roles)
    rids = role_ids & roles
    return rids.count>0
  end
  
  def self.roles
    return {:root => [1], :psetter=>[1,2], :g_user => [1,2,3]}
  end
end
