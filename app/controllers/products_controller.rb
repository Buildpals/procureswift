# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /products
  def index
    session[:query] = params[:query]
    session[:retailer] = params[:retailer]
    @products = Product.where(query = params[:query],
                              retailer = params[:retailer])
  rescue Zinc::ZincError
    redirect_to root_path, alert: "Sorry, we couldn't connect to " \
                                  "#{params[:retailer].titleize} at this " \
                                  'time, please try again later.'
  end

  # GET /products/1
  def show
    @product = Product.find(params[:id])
    @offer = @product.offers.find { |offer| offer.id == params[:offer_id] } ||
             @product.offers.first
  rescue Zinc::ZincError
    retailer, _product_id = Product.split_retailer_from_product_id(params[:id])
    redirect_to root_path, alert: "Sorry, we couldn't connect to " \
                                  "#{retailer.titleize} at this time, " \
                                  'please try again later.'
  rescue Zinc::ZincArgumentError
    raise ActionController::RoutingError, "Sorry we couldn't find that page."
  end
end
