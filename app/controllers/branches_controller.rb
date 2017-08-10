class BranchesController < ApplicationController
	def new 
		@branch = Branch.new 
	end
	def create 
	  @branch = Branch.create(branch_params)
	  @branch.business = Business.first
	  if @branch.save 
	    redirect_to settings_url, notice: "Branch created successfully"
	  else
	    render :new 
	  end 
	end

	private 
	def branch_params
		params.require(:branch).permit(:name)
	end
end 