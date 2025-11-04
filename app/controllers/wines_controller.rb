class WinesController < ApplicationController
  def index
    @wines = Wine.all
  end

  def show
    @wine = Wines.find(params[:id])
  end
end
