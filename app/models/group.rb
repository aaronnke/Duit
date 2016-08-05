class Group < ActiveRecord::Base
  has_many :allocations
  has_many :users, :through => :allocations
end
