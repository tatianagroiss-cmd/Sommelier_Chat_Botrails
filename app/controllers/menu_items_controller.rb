class MenuItemsController < ApplicationController
  def index
    @menu_items = MenuItem.all
  end

  def show
    @Menu_item = MenuItem.find(params[:id])
  end
end
