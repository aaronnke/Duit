class RegistrationsController < Devise::RegistrationsController
	def sign_up_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me, :avatar)
	end 

	def account_update_params
    	params.require(:user).permit(:name,:email, :password, :password_confirmation, :current_password, :avatar, :remove_avatar)
  	end
end
