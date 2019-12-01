require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "creating a Product" do
    visit products_url
    click_on "New Product"

    fill_in "Delivery method", with: @product.delivery_method
    fill_in "Delivery region", with: @product.delivery_region
    fill_in "Full name", with: @product.full_name
    fill_in "Item quantity", with: @product.item_quantity
    fill_in "Item url", with: @product.item_url
    fill_in "Phone number", with: @product.phone_number
    fill_in "Zinc product details", with: @product.zinc_product_details
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "updating a Product" do
    visit products_url
    click_on "Edit", match: :first

    fill_in "Delivery method", with: @product.delivery_method
    fill_in "Delivery region", with: @product.delivery_region
    fill_in "Full name", with: @product.full_name
    fill_in "Item quantity", with: @product.item_quantity
    fill_in "Item url", with: @product.item_url
    fill_in "Phone number", with: @product.phone_number
    fill_in "Zinc product details", with: @product.zinc_product_details
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "destroying a Product" do
    visit products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product was successfully destroyed"
  end
end
