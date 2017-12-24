class Api::CitiesController < ApplicationController
  # GET /cities
  def index
    cities = City.filter_by(params).includes(:region, :metro_stations)
    render json: cities
  end

  # GET /cities/:id
  def show
    city = City.find(params[:id])
    render json: as_json_without_root(city)
  end
end
