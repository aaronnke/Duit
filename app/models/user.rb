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
  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    user.email = auth.info.email
	    user.password = Devise.friendly_token[0,20]
	    user.name = auth.info.name   # assuming the user model has a name
	    user.avatar = auth.info.avatar # assuming the user model has an image
	  end
	end
end
