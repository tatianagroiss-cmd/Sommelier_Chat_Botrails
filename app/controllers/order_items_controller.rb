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
    if @order_item.save
      redirect_to @order_item, notice: 'Order item was successfully created.'
    else
      render :new
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:user_id, :menu_item_id, :wine_id, :beverage_id, :quantity)
  end
end
