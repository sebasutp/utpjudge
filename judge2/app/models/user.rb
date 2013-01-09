class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_and_belongs_to_many :roles
  # attr_accessible :title, :body
  
  def has_roles(roles)
    rids = role_ids & roles
    return rids.count>0
  end
  
  def self.roles
    return {:root => [1], :psetter=>[1,2], :g_user => [1,2,3]}
  end
end
