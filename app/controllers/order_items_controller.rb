class OrderItemsController < ApplicationController
  def index
    @order_items = current_user.order_items.includes(:menu_item, :wine, :beverage)
    @total_price = @order_items.sum(:total)
  end

  def show
    @order_item = OrderItem.find(params[:id])
  end

  def new
    @order_item = OrderItem.new
  end

  def create
    @order_item = OrderItem.new(order_item_params)
    @order_item.user = current_user

    if @order_item.save
      #redirect_to order_items_path, notice: "Item added to your order."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    #redirect_to order_items_path, notice: "Item removed from your order."
  end

  private

  def order_item_params
    params.require(:order_item).permit(:user, :menu_item_id, :wine_id, :beverage_id, :quantity, :total)
  end
end
