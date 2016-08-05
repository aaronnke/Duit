class Group < ActiveRecord::Base
  has_many :allocations
  has_many :users, :through => :allocations
  validates :group_token, uniqueness: true 
  before_create :generate_group_token

  def generate_group_token
  	group_token = SecureRandom.hex(6)
  	byebug 
  		group_token = SecureRandom.hex(6) until Group.find_by(group_token: group_token) == nil
  	self.group_token = group_token
  	end 
end
