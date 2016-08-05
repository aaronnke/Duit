class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  mount_uploader :avatar, AvatarUploader
  
  has_many :allocations
  has_many :groups, :through => :allocations
  has_many :bank_accounts
end
