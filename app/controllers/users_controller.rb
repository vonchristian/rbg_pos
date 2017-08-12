class UsersController < ApplicationController
	def new 
		@user = User.new 
		authorize @user
	end 
	def create
		@user = User.create(user_params)
		authorize @user
		if @user.valid?
			@user.save 
			redirect_to settings_url, notice: "Employee registered successfully."
		else 
			render :new 
		end 
	end 

	private
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation, :role)
	end 
end 