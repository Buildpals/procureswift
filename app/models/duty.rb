# frozen_string_literal: true

class Duty
  def initialize(cost, insurance, freight)
    raise ArgumentError, 'cost is nil' if cost.nil?
    raise ArgumentError, 'insurance is nil' if insurance.nil?
    raise ArgumentError, 'freight is nil' if freight.nil?

    @cost = cost
    @insurance = insurance
    @freight = freight
    @cif = @cost + @insurance + @freight
  end

  def show_calculation
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>"
    puts "cost #{@cost}"
    puts "insurance #{@insurance}"
    puts "freight #{@freight}"
    puts "cif #{@cif}"
    puts "-------------------"
    puts "get_fund #{get_fund}"
    puts "ecowas_levy #{ecowas_levy}"
    puts "cassette_levy #{cassette_levy}"
    puts "customs_inspection_fee #{customs_inspection_fee}"
    puts "irs_tax_deposit #{irs_tax_deposit}"
    puts "import_levy #{import_levy}"
    puts "environmental_excise #{environmental_excise}"
    puts "special_import_levy #{special_import_levy}"
    puts "exim #{exim}"
    puts "au_import_levy #{au_import_levy}"
    puts "miscellaneous_pen #{miscellaneous_pen}"
    puts "processing_fee #{processing_fee}"
    puts "import_excise #{import_excise}"
    puts "customs_penalty #{customs_penalty}"
    puts "import_duty #{import_duty}"
    puts "import_vat #{import_vat}"
    puts "import_nhil #{import_nhil}"
    puts "---------------"
    puts "total_duty_payable #{total_duty_payable}"
  end

  def total_duty_payable
    get_fund +
        ecowas_levy +
        cassette_levy +
        customs_inspection_fee +
        irs_tax_deposit +
        import_levy +
        environmental_excise +
        special_import_levy +
        exim +
        au_import_levy +
        miscellaneous_pen +
        processing_fee +
        import_excise +
        customs_penalty +
        import_duty +
        import_vat +
        import_nhil
  end

  def get_fund
    # 2.5%
    @cif * (2.5 / 100.0)
  end

  def ecowas_levy
    # 0.5%
    @cif * (0.5 / 100.0)
  end

  def cassette_levy
    # 20% if applicable
    applicable = false
    if applicable
      @cif * (20 / 100.0)
    else
      0
    end
  end

  def customs_inspection_fee
    # 1%
    @cif * (1 / 100.0)
  end

  def irs_tax_deposit
    # TODO: Get real percentage
    # 1%
    @cif * (1 / 100.0)
  end

  def import_levy
    # TODO: Get real percentage
    # 0%
    @cif * (0 / 100.0)
  end

  def environmental_excise
    # TODO: Get real percentage
    # 0%
    @cif * (0 / 100.0)
  end

  def special_import_levy
    # TODO: Get real percentage
    # 2%
    @cif * (2 / 100.0)
  end

  def exim
    # TODO: Get real percentage
    # 0.75%
    @cif * (0.75 / 100.0)
  end

  def au_import_levy
    # TODO: Get real percentage
    # 0.2%
    @cif * (0.2 / 100.0)
  end

  ####

  def miscellaneous_pen
    # TODO: Get real percentage
    # 0 %
    @cif * (0 / 100.0)
  end

  def processing_fee
    # TODO: Get real percentage
    # 1%
    @cif * (1 / 100.0)
  end

  def import_excise
    # TODO: Calculate based on whether the item is restricted, e.g. tobacco, alcohol, etc
    # 0 %
    @cif * (0 / 100.0)
  end

  def customs_penalty
    # TODO: Get real percentage
    # 0 %
    @cif * (0 / 100.0)
  end

  #####

  def import_duty
    # TODO: Figure out import_duty rate based on HSCODE using 10 for now
    # 0%, 5%, 10% or 20%
    @cif * (5 / 100.0)
  end

  def import_vat
    # 15%
    @cif * (15 / 100.0)
  end

  def import_nhil
    # 2.5%
    @cif * (2.5 / 100.0)
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
