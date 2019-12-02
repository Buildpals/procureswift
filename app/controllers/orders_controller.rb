# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show edit update destroy]
  before_action :set_product, except: %i[admin_index index]

  # GET /orders
  # GET /orders.json
  def index
    @orders = current_user.orders
  end

  def admin_index
    @orders = if current_user.admin?
                Order.all
              else
                current_user.orders
              end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show; end

  # GET /orders/new
  def new
    @order = @product.orders.build
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders
  # POST /orders.json
  def create
    @order = @product.orders.build(order_params)
    @order.user = current_user

    respond_to do |format|
      if @order.save
        format.html { redirect_to product_order_path(@product, @order), notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
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

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:product_id, :user_id, :chosen_offer_id, :quantity, :delivery_method, :full_name, :address, :region, :city_or_town, :phone_number, :email, :txtref, :status)
  end
end
