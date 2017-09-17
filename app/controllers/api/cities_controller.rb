class Api::CitiesController < ApplicationController
  # GET /cities
  def index
    @cities = City.filter_by(params)
    render json: @cities
  end

  # GET /cities/1
  def show
    @city = City.find(params[:id])
    render json: @city
  end
end