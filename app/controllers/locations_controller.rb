class LocationsController < ApplicationController
  def new
    @location = []

    2.times do
     @location << Location.new
   end
  end


  def create
    if params.has_key?("location")
      Location.create(location_params(params["location"]))
    else
      params["locations"].each do |location|
        if location["address"] != ""
          Location.create(location_params(location))

          

        end
      end
      redirect_to(:action => :index, :notice => "Successfully updated feature.") and return
    end
  end

  def index
    @locations = Location.all
  end

  def edit
  end

  def show
  end

  private



  def location_params(my_params)
    my_params.permit(:address, :latitude, :longitude)
  end

end
