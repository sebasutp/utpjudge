class User < ActiveRecord::Base
  attr_accessible :code, :email, :encrypted_password, :name
end
