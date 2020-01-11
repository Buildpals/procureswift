# frozen_string_literal: true

class Dimensions
  OUNCE_TO_POUND_RATIO = 0.0625

  def initialize(zinc_product_details)
    if zinc_product_details['package_dimensions'].nil?
      raise ArgumentError, 'package_dimensions is nil'
    end
    if zinc_product_details['package_dimensions']['size'].nil?
      raise ArgumentError, 'package_dimensions >> size'
    end
    if zinc_product_details['package_dimensions']['size']['depth'].nil?
      raise ArgumentError, 'package_dimensions >> size >> depth'
    end
    if zinc_product_details['package_dimensions']['size']['depth']['amount'].nil?
      raise ArgumentError, 'package_dimensions >> size >> depth >> amount'
    end

    @zinc_product_details = zinc_product_details
  end

  def depth
    return nil if @zinc_product_details['package_dimensions']['size'].nil?
    if @zinc_product_details['package_dimensions']['size']['depth'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['depth']['amount'].nil?
      return nil
    end

    @zinc_product_details['package_dimensions']['size']['depth']['amount']
  end

  def depth_unit
    return nil if @zinc_product_details['package_dimensions']['size'].nil?
    if @zinc_product_details['package_dimensions']['size']['depth'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['depth']['unit'].nil?
      return nil
    end

    @zinc_product_details['package_dimensions']['size']['depth']['unit']
  end

  def length
    return nil if @zinc_product_details['package_dimensions']['size'].nil?
    if @zinc_product_details['package_dimensions']['size']['length'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['length']['amount'].nil?
      return nil
    end

    @zinc_product_details['package_dimensions']['size']['length']['amount']
  end

  def length_unit
    return nil if @zinc_product_details['package_dimensions']['size'].nil?
    if @zinc_product_details['package_dimensions']['size']['length'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['length']['unit'].nil?
      return nil
    end

    @zinc_product_details['package_dimensions']['size']['length']['unit']
  end

  def width
    return nil if @zinc_product_details['package_dimensions']['size'].nil?
    if @zinc_product_details['package_dimensions']['size']['width'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['width']['amount'].nil?
      return nil
    end

    @zinc_product_details['package_dimensions']['size']['width']['amount']
  end

  def width_unit
    return nil if @zinc_product_details['package_dimensions']['size'].nil?
    if @zinc_product_details['package_dimensions']['size']['width'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['width']['unit'].nil?
      return nil
    end

    @zinc_product_details['package_dimensions']['size']['width']['unit']
  end

  def volume
    return nil if width.nil?
    return nil if length.nil?
    return nil if depth.nil?

    width * length * depth
  end

  def weight
    return nil if @zinc_product_details['package_dimensions']['weight'].nil?
    if @zinc_product_details['package_dimensions']['weight']['amount'].nil?
      return nil
    end

    @zinc_product_details['package_dimensions']['weight']['amount']
  end

  def weight_unit
    return nil if @zinc_product_details['package_dimensions']['weight'].nil?
    if @zinc_product_details['package_dimensions']['weight']['unit'].nil?
      return nil
    end

    @zinc_product_details['package_dimensions']['weight']['unit']
  end

  def weight_in_pounds
    case weight_unit
    when 'pounds'
      weight
    when 'ounces'
      weight * OUNCE_TO_POUND_RATIO
    else
      weight
    end
  end

  def hash
    weight_in_pounds.hash
  end

  def eql?(other)
    to_s == other.to_s
  end

  def to_s
    weight_in_pounds.to_s
  end
end
