# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show edit update destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order.fetch_item_information
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
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
    if params[:commit] == 'Make Payment'
      respond_to do |format|
        if @order.update(order_params)
          format.html { redirect_to @order, notice: 'Order was successfully updated.' }
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
          format.html { redirect_to @order, notice: 'Order was successfully updated.' }
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

  def payment
    @order = Order.find(params['order_id'])
    @order.txtref = params['txtref']
    @order.full_name = params['full_name']
    @order.phone_number = params['phone_number']
    @order.email = params['email']
    @order.status = 0
    @order.save!
  end

  def payment_status; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:item_url,
                                  :item_quantity,
                                  :delivery_method,
                                  :delivery_region,
                                  :full_name,
                                  :email,
                                  :phone_number,
                                  :chosen_offer_id)
  end
end
