class TripSuppliesController < ApplicationController

  def increase
    trip_supply = TripSupply.find(params[:id])
    trip = Trip.find(trip_supply.trip_id)
    trip_supply.increase_quantity
    trip_supply.save
    redirect_to user_trip_path(current_user, trip)
  end

  def decrease
    trip_supply = TripSupply.find(params[:id])
    trip = Trip.find(trip_supply.trip_id)
    trip_supply.decrease_quantity
    trip_supply.save
    redirect_to user_trip_path(current_user, trip)
  end
end
