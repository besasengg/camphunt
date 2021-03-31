class TripsController < ApplicationController

  def index
    @trips = current_user.trips
    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @trips }
    end
  end

  def upcoming
    @trips = current_user.trips.upcoming
    render :json => @trips
  end

  def description
    trip = Trip.find(params[:id])
    render :plain => trip.description
  end

  def favorites
    @fav_trips = Trip.where(user_id: current_user.id, favorite: true)
  end

  def results
    response = Faraday.get do |req|
      req.url "http://api.amp.active.com/camping/campgrounds/?"
	  #req.params['api_key'] = Rails.application.secrets.active_api_key
	  req.params['api_key'] = Rails.application.secrets.active_api_key
      req.params['pname'] = params["pname"]
    end
    @json = JSON.parse(Hash.from_xml(response.body).to_json)
    if @json["resultset"]["count"] == "0"
      flash[:error] = "Park not found"
      redirect_to root_path
    end
  end

  def new
    @trip = Trip.new
    @name = params[:name]
    response = Faraday.get do |req|
      req.url "http://api.amp.active.com/camping/campground/details?"
      req.params['api_key'] = Rails.application.secrets.active_api_key
      req.params['contractCode'] = params[:contract_code]
      req.params['parkId'] = params[:park_id]
    end
    json = JSON.parse(Hash.from_xml(response.body).to_json)
    @description = json["detailDescription"]["description"]
  end

  def create
    @trip = current_user.trips.create(trip_params)
    if @trip.save
      flash[:notice] = "Trip Saved"
      redirect_to user_trip_path(current_user, @trip)
    else
      render 'new'
    end
  end

  def show
    @trip = Trip.find(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { render :json => @trip}
    end
  end

  def update
    @trip = Trip.find(params[:id])
    @trip.update(trip_params)
    if @trip.save
      render 'supplies/show', :layout => false
    else
      flash[:error] = @errors
      redirect_to user_trip_path(current_user, @trip)
    end
  end

  def update_favorite_status
    trip = Trip.find(params[:id])
    trip.favorite = !trip.favorite
    trip.save
    redirect_to user_trip_path(current_user, trip)
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :description, :favorite, :start_date, :end_date, :user_id, :supplies_attributes => [:name])
  end
end
