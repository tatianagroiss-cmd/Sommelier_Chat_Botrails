class WinesController < ApplicationController
  def index
    @wines = Wines.all
  end

  def show
    @wine = Wines.find(params[:id])
  end
end
