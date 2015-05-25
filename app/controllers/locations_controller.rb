class LocationsController < ApplicationController
	before_action :set_location, only: [:show, :edit, :update, :destroy]

	# GET /locations
	# GET /locations.json
	def index
		if params[:search].present?
			@locations = Location.near(params[:search], 10, :order => distance)
		else
			@locations = Location.all
		end
	end

	def search
		@destinations = Location.all.where("current_forecast like ?", params[:weather]).sort_by{ |d|
			d.distance_to([params[:latitude].to_f, params[:longitude].to_f])
		}.first

		@conditions = ""

		if @destinations
			if params[:weather] == "rain"
				@conditions = "raining"
			elsif params[:weather] == "snow"
				@conditions = "snowing"
			elsif params[:weather] == "clear%"
				@conditions = "sunny"
			else
				@conditions = "different"
			end
		else
			flash[:alert] = "There doesn't appear to be any " + params[:weather].to_s + " anywhere in the U.S. today."
			redirect_to controller: :home, action: :index
		end
	end

	# GET /locations/1
	# GET /locations/1.json
	def show
	end

	# GET /locations/new
	def new
		@location = Location.new
	end

	# GET /locations/1/edit
	def edit
	end

	# POST /locations
	# POST /locations.json
	def create
		@location = Location.new(location_params)

		respond_to do |format|
			if @location.save
				format.html { redirect_to @location, notice: 'Location was successfully created.' }
				format.json { render :show, status: :created, location: @location }
			else
				format.html { render :new }
				format.json { render json: @location.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /locations/1
	# PATCH/PUT /locations/1.json
	#  def update
	#    respond_to do |format|
	#      if @location.update(location_params)
	#        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
	#        format.json { render :show, status: :ok, location: @location }
	#      else
	#        format.html { render :edit }
	#        format.json { render json: @location.errors, status: :unprocessable_entity }
	#      end
	#    end
	#  end

	# DELETE /locations/1
	# DELETE /locations/1.json
	def destroy
		@location.destroy
		respond_to do |format|
			format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_location
		@location = Location.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def location_params
		params.require(:location).permit(:city, :state, :latitude, :longitude)
	end
end
