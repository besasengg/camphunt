class SuppliesController < ApplicationController

  def index
    @trip = Trip.find(params[:trip_id])
    @supplies = @trip.supplies
  end

  private

  def supply_params
    params.require(:supply).permit(:name)
  end
end
