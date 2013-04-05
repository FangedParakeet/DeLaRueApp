class User < ActiveRecord::Base
  attr_accessible :city, :country, :display_location, :display_name, :email, :firstname, :lastname, :photo, :user_type, :use_uid, :username, :password, :password_confirmation
  
  validates :email, :presence => true
  validates :password, :presence => true
  validates :password_confirmation, :presence => true
  
  has_secure_password
  
  has_many :artists
end
