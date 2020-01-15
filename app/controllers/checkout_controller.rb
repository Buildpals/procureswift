# frozen_string_literal: true

class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[payment]

  def payment
  end

  # POST /orders
  def create
    @order = current_cart.build_order(order_params)
    @order.user = current_user

    if @order.save
      if @order.purchased?
        redirect_to order_path(@order), notice: 'Order was successfully created.'
      else
        flash.now[:notice] = 'Payment failed, please try again'
        render :new
      end
    else
      render :new
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = current_user.orders.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:user_id,
                                  :delivery_method,
                                  :full_name,
                                  :address,
                                  :region,
                                  :city_or_town,
                                  :phone_number,
                                  :txtref,
                                  :status,
                                  :purchased)
  end
end
