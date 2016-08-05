class Transaction < ActiveRecord::Base
  belongs_to :bank_account
  belongs_to :tag
end
