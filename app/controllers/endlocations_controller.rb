class EndlocationsController < ApplicationController
  def new
    @location = Endlocation.new


  end


  def create
    puts params
    @locations = Endlocation.new(location_params)



    if @locations.save
      redirect_to :action => :index, notice: "Topic was saved successfully."

    end
  end

  def index
    @locations = Endlocation.all
  end

  def edit
  end

  def show
  end

  private

  def location_params
    params.require(:endlocation).permit(:address, :latitude, :longitude)
  end
end
