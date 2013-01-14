require 'digest'
class User < ActiveRecord::Base
  attr_accessible :code, :email, :encrypted_password, :name
  attr_accessor :password
  has_many :submissions
  has_and_belongs_to_many :roles
  validates :password, {:confirmation => true, :length=>{:within => 6..50},
    :presence => true, :if => password_required?}
  validates :email, {:presence=>true, :format => {:with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i}}

  def after_create
    r = Role.find(3)
    self.roles << r
  end

  def has_roles(roles)
    rids = role_ids & roles
    return rids.count>0
  end

  def authenticated?(password)
    return self.hashed_password == encrypt(password)
  end

  def self.authenticate(email,password)
    user = User.find_by_email(email)
    return user if user and user.authenticated?(password)
  end
  
  def self.roles
    return {:root => [1], :psetter=>[1,2], :g_user => [1,2,3]}
  end

protected

  def encrypt_new_password
    if not password.blank?
      self.hashed_password = encrypt(password)
    end
  end

  def password_required?
    return encrypted_password.blank? || password.present?
  end

  def encrypt(str)
    return Digest::SHA256.hexdigest(str)
  end
end
