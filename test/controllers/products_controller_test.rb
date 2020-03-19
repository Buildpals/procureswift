require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get product_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: {delivery_method: @product.delivery_method, delivery_region: @product.delivery_region, full_name: @product.full_name, item_quantity: @product.item_quantity, item_url: @product.item_url, phone_number: @product.phone_number, product_details_json: @product.product_details_json } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: {delivery_method: @product.delivery_method, delivery_region: @product.delivery_region, full_name: @product.full_name, item_quantity: @product.item_quantity, item_url: @product.item_url, phone_number: @product.phone_number, product_details_json: @product.product_details_json } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
