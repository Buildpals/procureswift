# frozen_string_literal: true

class ProductBuilder
  CENTS_TO_DOLLARS_RATIO = 0.01

  def initialize(product_details_json, offers)
    @product_details_json = product_details_json
    @offers = offers
  end

  def build
    product = Product.new
    product.product_id = @product_details_json['product_id']
    product.retailer = @product_details_json['retailer']
    product.title = @product_details_json['title']
    product.main_image = @product_details_json['main_image']

    product.weight = weight
    product.width = width
    product.length = length
    product.depth = depth

    product.price = price
    product.stars = @product_details_json['stars']
    product.num_reviews = @product_details_json['num_reviews']

    product.offers = @offers
    product
  end

  private

  def weight
    return nil if @product_details_json['package_dimensions'].nil?
    return nil if @product_details_json['package_dimensions']['weight'].nil?
    if @product_details_json['package_dimensions']['weight']['amount'].nil?
      return nil
    end
    if @product_details_json['package_dimensions']['weight']['unit'].nil?
      return nil
    end

    weight = @product_details_json['package_dimensions']['weight']['amount']
    unit = @product_details_json['package_dimensions']['weight']['unit']

    Unitwise(weight, unit.singularize).to_pound.to_f
  end

  def depth
    return nil if @product_details_json['package_dimensions'].nil?
    return nil if @product_details_json['package_dimensions']['size'].nil?
    if @product_details_json['package_dimensions']['size']['depth'].nil?
      return nil
    end
    if @product_details_json['package_dimensions']['size']['depth']['amount'].nil?
      return nil
    end
    if @product_details_json['package_dimensions']['size']['depth']['unit'].nil?
      return nil
    end

    depth = @product_details_json['package_dimensions']['size']['depth']['amount']
    unit = @product_details_json['package_dimensions']['size']['depth']['unit']

    Unitwise(depth, unit.singularize).to_inch.to_f
  end

  def length
    return nil if @product_details_json['package_dimensions'].nil?
    return nil if @product_details_json['package_dimensions']['size'].nil?
    if @product_details_json['package_dimensions']['size']['length'].nil?
      return nil
    end
    if @product_details_json['package_dimensions']['size']['length']['amount'].nil?
      return nil
    end
    if @product_details_json['package_dimensions']['size']['length']['unit'].nil?
      return nil
    end

    length = @product_details_json['package_dimensions']['size']['length']['amount']
    unit = @product_details_json['package_dimensions']['size']['length']['unit']

    Unitwise(length, unit.singularize).to_inch.to_f
  end

  def width
    return nil if @product_details_json['package_dimensions'].nil?
    return nil if @product_details_json['package_dimensions']['size'].nil?
    if @product_details_json['package_dimensions']['size']['width'].nil?
      return nil
    end
    if @product_details_json['package_dimensions']['size']['width']['amount'].nil?
      return nil
    end
    if @product_details_json['package_dimensions']['size']['width']['unit'].nil?
      return nil
    end


    unit = @product_details_json['package_dimensions']['size']['width']['unit']
    width = @product_details_json['package_dimensions']['size']['width']['amount']

    Unitwise(width, unit.singularize).to_inch.to_f
  end

  def price
    return nil unless @product_details_json['price']

    @product_details_json['price'] * CENTS_TO_DOLLARS_RATIO
  end
end
