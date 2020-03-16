# frozen_string_literal: true

class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[update destroy]

  def create
    current_cart.add_product(cart_item_params)

    if current_cart.save
      redirect_to cart_path(current_cart), notice: 'Item added to cart successfully.'
    else
      redirect_to @product, alert: 'There was a problem adding this item to your cart.'
    end
  end

  # PATCH/PUT /cart_items/1
  def update
    if @cart_item.update(cart_item_params)
      redirect_to cart_path(current_cart), notice: 'Cart was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /cart_items/1
  def destroy
    @cart_item.destroy
    redirect_to cart_path(current_cart), notice: 'Item removed from cart successfully.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cart_item_params
    params.require(:cart_item).permit(:product_id,
                                      :quantity,
                                      :chosen_offer_id)
  end
end
