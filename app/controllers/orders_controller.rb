# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show]

  # GET /orders
  def index
    @orders = current_user.orders.all
  end

  # GET /orders/1
  def show; end

  # GET /orders/new
  def new
    @order = current_cart.build_order
  end

  # POST /orders
  def create
    @order = current_cart.build_order(order_params)
    @order.user = current_user

    if RavePayVerifier.new(current_cart).purchased?(order_params[:txtref]) == false
      flash.now[:alert] = 'There was an issue while trying to process your payment.'
      render(:new) && return
    end

    @order.cart.update!(purchased_at: Time.current)
    @order.save!
    redirect_to @order, notice: 'Order was placed successfully.', flash: { thanks_for_shopping_with_us: true }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = current_user.orders.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:txtref)
  end
end
