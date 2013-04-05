class Artist < ActiveRecord::Base
  attr_accessible :likes, :name, :type, :user_id
  
  belongs_to :user
end
