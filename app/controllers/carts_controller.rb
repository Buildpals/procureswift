# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :set_cart

  # GET /carts/1
  def show
    @cart = current_cart
  end

  def edit; end

  # PATCH/PUT /carts/1
  def update
    if @cart.update(cart_params)
      redirect_to new_order_path
    else
      render :edit
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = current_cart
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cart_params
    params.require(:cart).permit(:user_id,
                                 :delivery_method,
                                 :full_name,
                                 :address,
                                 :region,
                                 :city_or_town,
                                 :phone_number)
  end
end
