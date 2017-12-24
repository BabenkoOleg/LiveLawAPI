class Api::RegionsController < ApplicationController
  def index
    regions = Region.all.includes(:cities)
    render json: regions
  end

  def show
    region = Region.find(params[:id])
    render json: as_json_without_root(region, show_cities: true)
  end
end
