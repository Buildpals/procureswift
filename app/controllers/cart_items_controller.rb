# frozen_string_literal: true

class CartItemsController < ApplicationController
  before_action :set_cart, only: %i[create update destroy]
  before_action :set_cart_item, only: %i[update destroy]

  def create
    @cart.add_product(cart_item_params)

    if @cart.save
      redirect_to cart_path(@cart), notice: 'Item added to cart successfully.'
    else
      flash[:error] = 'There was a problem adding this item to your cart.'
      redirect_to @product
    end
  end

  # PATCH/PUT /cart_items/1
  # PATCH/PUT /cart_items/1.json
  def update
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html { redirect_to cart_path(@cart), notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart_item }
      else
        format.html { render :edit }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cart_items/1
  # DELETE /cart_items/1.json
  def destroy
    @cart_item.destroy
    respond_to do |format|
      format.html { redirect_to cart_path(@cart), notice: 'Item removed from cart successfully.' }
      format.json { head :no_content }
    end
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
