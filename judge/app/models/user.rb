require 'digest'
class User < ActiveRecord::Base
  attr_accessible :code, :email, :encrypted_password, :name
  attr_accessor :password
  before_save :encrypt_new_password
  has_many :submissions
  has_and_belongs_to_many :roles
  validates :password, {:confirmation => true, :length=>{:within => 6..50},
    :presence => true, :if => :password_required?}
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
    return self.encrypted_password == encrypt(password)
  end

  def self.authenticate(params)
    user = User.find_by_email(params[:email])
    if user and user.authenticated?(params[:password])
      return user
    else
      return nil
    end
  end
  
  def self.roles
    return {:root => [1], :psetter=>[1,2], :g_user => [1,2,3]}
  end
  
  def self.newMA(params)
    u = User.new
    u.name = params[:name]
    u.email = params[:email]
    u.password = params[:password]
    u.password_confirmation = params[:password_confirmation]
    u.code = params[:code]
    return u
  end

protected

  def encrypt_new_password
    if not password.blank?
      self.encrypted_password = encrypt(password)
    end
  end

  def password_required?
    return encrypted_password.blank? || password.present?
  end

  def encrypt(str)
    return Digest::SHA256.hexdigest(str)
  end
end
