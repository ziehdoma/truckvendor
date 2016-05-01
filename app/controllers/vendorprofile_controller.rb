class VendorprofileController < ApplicationController
	
	before_action :params_set, only: [:show, :edit, :update, :destroy]
  	
	def index  
		@vendorprofiles = Vendorprofile.all		
	end 
	
	
	def new
		@vendorprofile = Vendorprofile.new
	end 

	def create
		@vendorprofile = Vendorprofile.new(vendor_params)
		if @vendorprofile.save
			redirect_to vendor_path(@vendorprofile), notice: "New Profile Created"
		else 
			render :new
		end 
	end 

	def show
		
	end 
	
	def edit
	end 

	def update
		if @vendorprofile.update(vendor_params)
			redirect_to vendor_path(@vendorprofile)
		else 
			render :edit
		end 
	end 

	def destroy
		params_set
		@vendorprofile.destroy
			redirect_to root_path, alert: "profile deleted"	
	end 

	
	private

	def params_set
		@vendorprofile = Vendorprofile.find(params[:id])

	end 
	def vendor_params
		params.require(:vendorprofile).permit(:name, :address, :zipcode, :description, :phone, :longitude, :latitude)
	end 

end
