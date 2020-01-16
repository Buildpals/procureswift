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
  def show
    if session["has_viewed_product_#{@product.id}"].nil?
      unless ItemInformationFetcher.new(@product).fetch_item_information
        redirect_to root_path, notice: 'We are unable to process your request at this time. Please Try again later.'
      end
      session["has_viewed_product_#{@product.id}"] = true
    end
  end

  # POST /products
  def create
    retailers_product_id = Amazon.get_asin_from_url(product_params[:item_url])

    if retailers_product_id == false
      redirect_to(root_path, notice: 'Please provide a valid Amazon url') && return
    end

    @product = Product.find_by("zinc_product_details->>'product_id' = ?", retailers_product_id)
    redirect_to(@product) && return if @product

    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render 'welcome/index'
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
                                    :full_name,
                                    :phone_number,
                                    :chosen_offer_id)
  end
end
