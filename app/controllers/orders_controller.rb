# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show edit update destroy]

  # GET /orders
  def index
    @orders = Order.all
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

    if @order.purchased?(current_cart) == false
      flash.now[:alert] = 'There was an issue while trying to process your payment'
      render :new
      return
    else
      flash.now[:notice] = 'Payment would have been successful'
      render :new
      return
    end

    #@order.cart.update!(purchased_at: Time.current)
    #@order.save!
    #redirect_to @order, notice: 'Order was successfully placed.'
  end

  # PATCH/PUT /orders/1
  def update
    if params[:commit] && params[:commit][0, 12] == 'Make Payment'
      respond_to do |format|
        if @order.update(order_params)
          format.html { redirect_to product_order_path(@product, @order), notice: 'Order was successfully updated.' }
          format.js
          format.json { render :show, status: :ok, location: @order }
        else
          format.html { render :edit }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        if @order.update(order_params)
          format.html { redirect_to product_order_path(@product, @order), notice: 'Order was successfully updated.' }
          format.json { render :show, status: :ok, location: @order }
        else
          format.html { render :edit }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
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
