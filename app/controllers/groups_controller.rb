class GroupsController < ApplicationController

	def new 
		@group = Group.new 
	end 

	def create 
		@user = current_user
		@group = Group.new(group_params)

		@group.save  
		@user.groups << @group 

		redirect_to user_profile_path(current_user)
	end 

	def show 
		@users = User.all 
		@user = current_user
		@group = Group.find(params[:id])
	end 

	def edit 
		@users = User.all
		@user = current_user 
		@group = Group.find(params[:id])
	end 

	def destroy 
		@group = Group.find(params[:id])
		@group.destroy 
		redirect_to user_profile_path(current_user) 
	end 

	def update
		@group = Group.find(params[:id])
		if @group.update(group_params)
			redirect_to user_profile_path(current_user)
		end  
	end 

	def join 
		@user = current_user
		@group = Group.find_by(group_token:params[:group][:group_token]) 
		if @group.nil?
			flash[:notice] = "No such group. Make sure group token is correct!"
			redirect_to user_profile_path(current_user)
		
		else 
			@user.groups << @group 
			flash[:notice] = "Group found. Welcome to the tribe (:"
			redirect_to user_profile_path(current_user)

		end 
	end 

	def leave 
		@user = current_user 
		@group_leave = Allocation.find_by(user_id: current_user.id)
		@group_leave.destroy
		flash[:notice] = "You've left the group. They will miss you!"

		redirect_to user_profile_path(current_user)
	end 

private 
	
	def group_params 
		params[:group].permit(:group_name, :master_id)
	end 
end
