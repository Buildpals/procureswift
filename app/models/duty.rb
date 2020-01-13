# frozen_string_literal: true

class Duty
  def initialize(price, shipping_cost, quantity=1)
    raise ArgumentError, 'price is nil' if price.nil?
    raise ArgumentError, 'shipping_cost is nil' if shipping_cost.nil?

    @cif = price + shipping_cost
    @quantity = quantity
  end

  def cost
    (import_nhil +
      ecowas_levy +
      irs_tax_deposit +
      cassette_levy +
      miscellaneous_pen +
      special_import_levy +
      exim +
      au_import_levy +
      import_levy +
      customs_inspection_fee +
      processing_fee +
      environmental_excise +
      get_fund +
      import_duty +
      import_vat +
      import_excise +
      customs_penalty) * @quantity
  end

  def import_nhil
    @cif * 0.025
  end

  def ecowas_levy
    @cif * 0.02
  end

  def irs_tax_deposit
    @cif * 0.02
  end

  def cassette_levy
    @cif * 0.02
  end

  def miscellaneous_pen
    @cif * 0.02
  end

  def special_import_levy
    @cif * 0.02
  end

  def exim
    @cif * 0.02
  end

  def au_import_levy
    @cif * 0.02
  end

  def import_levy
    @cif * 0.02
  end

  def customs_inspection_fee
    @cif * 0.02
  end

  def processing_fee
    @cif * 0.02
  end

  def environmental_excise
    @cif * 0.02
  end

  def get_fund
    @cif * 0.02
  end

  def import_duty
    @cif * 0.10
  end

  def import_vat
    @cif * 0.15
  end

  def import_excise
    @cif * 0.02
  end

  def customs_penalty
    @cif * 0.02
  end

  def hash
    value.hash
  end

  def eql?(other)
    to_s == other.to_s
  end

  def to_s
    value.to_s
  end
end
