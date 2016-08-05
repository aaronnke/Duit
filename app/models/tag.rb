class Tag < ActiveRecord::Base
  has_many :transactions
end
