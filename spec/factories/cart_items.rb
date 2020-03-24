# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    cart

    quantity { (1..50).to_a.sample }
    unit_price { Faker::Commerce.price }
    weight { Faker::Number.within(range: 0.1..120) }
    seller_num_ratings { (0..9_000_000).to_a.sample }
    seller_percent_positive { Faker::Number.within(range: 0..100) }
    seller_first_party { (0..100).to_a.sample }
    seller_name { Faker::Company.name }
    seller_id { Faker::Internet.uuid }
    marketplace_fulfilled { [true, false].sample }
    international { [true, false].sample }
    offer_id { Faker::Internet.uuid }
    available { [true, false].sample }
    handling_days_max { (0..22).to_a.sample }
    handling_days_min { (0..22).to_a.sample }
    prime_only { [true, false].sample }

    condition do
      [
        'New',
        'Renewed',
        'Rental',
        'Used - Like New',
        'Used - Open Box',
        'Used - Very Good',
        'Used - Good',
        'Used - Acceptable',
        'Used'
      ].sample
    end

    addon { [true, false].sample }
    shipping_options { '[]' }

    product_id { Faker::Alphanumeric.alphanumeric(number: 10) }
    retailer { Product::RETAILERS.keys.sample }

    title { Faker::Commerce.product_name }

    # main_image { Faker::LoremPixel.image(size: "150x150", category: 'fashion') }
    main_image { '' }

    width { Faker::Number.within(range: 0.1..120) }
    length { Faker::Number.within(range: 0.1..120) }
    depth { Faker::Number.within(range: 0.1..120) }

    trait :single_quantity do
      quantity {1}
    end
  end
end
