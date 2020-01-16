# frozen_string_literal: true

class Admin::CartsController < ApplicationController
  before_action :set_cart, only: %i[show edit update destroy]

  # GET /carts
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  def show; end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit; end

  # POST /carts
  def create
    @cart = Cart.new(cart_params)

    if @cart.save
      redirect_to admin_cart_path(@cart), notice: 'Cart was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /carts/1
  def update
    if @cart.update(cart_params)
      redirect_to admin_cart_path(@cart), notice: 'Cart was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /carts/1
  def destroy
    @cart.destroy
    redirect_to admin_carts_url, notice: 'Cart was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cart_params
    params.require(:cart).permit(:archived)
  end
end
