class VendorprofileController < ApplicationController
	before_filter :authenticate_twilio_request, :only => [ :connect]
	before_action :params_set, only: [:show, :edit, :update, :destroy]

	@@twilio_sid = ENV['SK65f29896cba444f5a9522ea65eabf357']
  	@@twilio_token = ENV['29ce8c7bc011461b10ed6ea76572afc4']
  	
	def index
		if params[:search].present?
			@vendorprofiles = Vendorprofile.near(params[:serach], 50, :order => :distance)
		end  
			@vendorprofiles = Vendorprofile.all	
			
	end 

	def call 
		venorprofile = Vendorprofile.new
		vendorprofile.phone = params[:phone]

		 # Validate contact
    if contact.valid?

      @vendorprofile = Twilio::REST::Client.new @@twilio_sid, @@twilio_token
      # Connect an outbound call to the number submitted
      @call = @vendorprofile.account.calls.create(
        :from => @@twilio_number,
        :to => vendorprofile.phone,
        :url => "#{root_url}connect" # Fetch instructions from this URL when the call connects
      )

      # Lets respond to the ajax call with some positive reinforcement
      @msg = { :message => 'Phone call incoming!', :status => 'ok' }

    else

      # Oops there was an error, lets return the validation errors
      @msg = { :message => vendorprofile.errors.full_messages, :status => 'ok' }
    end
    respond_to do |format|
      format.json { render :json => @msg }
    end
	end 
	
	def connect
		response = Twilio::TwiML::Response.new do |r|
      	r.Say 'If this were a real click to call implementation, you would be connected to an agent at this point.', :voice => 'alice'
    end
    render text: response.text
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


	def authenticate_twilio_request
    twilio_signature = request.headers['HTTP_X_TWILIO_SIGNATURE']

    # Helper from twilio-ruby to validate requests. 
    @validator = Twilio::Util::RequestValidator.new(@@twilio_token)
 
    # the POST variables attached to the request (eg "From", "To")
    # Twilio requests only accept lowercase letters. So scrub here:
    post_vars = params.reject {|k, v| k.downcase == k}
 
    is_twilio_req = @validator.validate(request.url, post_vars, twilio_signature)
 
    unless is_twilio_req
      render :xml => (Twilio::TwiML::Response.new {|r| r.Hangup}).text, :status => :unauthorized
      false
    end
  end

end
