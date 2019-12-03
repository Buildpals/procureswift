# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show checkout edit update destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all.order(created_at: :desc)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product.fetch_item_information
  end

  def checkout; end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit; end

  # POST /products
  # POST /products.json
  def create
    retailers_product_id = Amazon.get_asin_from_url(product_params[:item_url])

    @product = Product.find_by("zinc_product_details->>'product_id' = ?", retailers_product_id)

    if @product
      respond_to do |format|
        format.html { redirect_to @product, notice: 'Looks like this product is very popular this season!' }
        format.json { render :show, status: :created, location: @product }
      end
    else
      @product = Product.new(product_params)

      respond_to do |format|
        if @product.save
          format.html { redirect_to @product, notice: 'Product was successfully created.' }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render 'welcome/index' }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def payment
    rave = RavePay.new
    response = rave.call(params[:txRef])
    response_charge_code = response['data']['chargecode']
    purchase_request_status = response['data']['status']
    @product = Product.find(params['product_id'])
    @product.txtref = params['txRef']
    @product.full_name = params['full_name']
    @product.phone_number = params['phone_number']
    @product.email = params['email']
    if response_charge_code == '00' || response_charge_code == '0'
      @product.status = 3
      @product.save!
    elsif response_charge_code == '02'
      @product.status = 0
      @product.save!
    else
      flash[:notice] = 'We could not complete your payment at this time. Please try again.'
      redirect_to action: 'checkout', id: @product.id
    end
  end

  def payment_status
    product = Product.where(txRef: params['txRef'])
    if params['status'] == 'successful'
      product.status = 3
      product.save!
    elsif params['status'] == 'failed'
      product.status = 1
      product.save!
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
                                    :item_quantity,
                                    :delivery_method,
                                    :delivery_region,
                                    :full_name,
                                    :address,
                                    :city_or_town,
                                    :email,
                                    :phone_number,
                                    :chosen_offer_id)
  end
end
