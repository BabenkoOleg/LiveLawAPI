class Api::CategoriesController < ApplicationController
  # GET /categories
  def index
    @categories = Category.all
    render json: @categories
  end

  # GET /categories/:id
  def show
    @category = Category.find(params[:id])
    render json: @category, show_prices: true
  end
end
