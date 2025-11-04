class BeveragesController < ApplicationController
  def index
    @beverages = Beverage.all
  end

  def show
    @beverage = Beverage.find(params[:id])
  end
end
