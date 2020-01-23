# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_product, only: %i[show update]

  # GET /products
  def index
    @products = Product
                .where.not(zinc_product_details: nil)
                .order(created_at: :desc)
  end

  # GET /products/1
  def show; end

  # GET /products/new
  def new
    @product = Product.new
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:item_url,
                                    :title,
                                    :price,
                                    :weight,
                                    :width,
                                    :depth,
                                    :hs_code,
                                    :length,
                                    :chosen_offer_id)
  end
end
