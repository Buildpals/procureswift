# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    user
    paid_at do
      Faker::Time.between(
        from: DateTime.now - 1, to:
        DateTime.now, format: :default
      )
    end

    full_name { Faker::Name.name }
    address { Faker::Address.street_address }
    region { Cart.regions.keys.sample }
    city_or_town { Faker::Address.city }

    phone_number { Faker::PhoneNumber.cell_phone }

    delivery_method { Cart.delivery_methods.keys.sample }

    archived { [true, false].sample }


    factory :cart_with_cart_items do
      transient do
        cart_items_count { 3 }
      end

      after(:create) do |cart, evaluator|
        create_list(:cart_item, evaluator.cart_items_count, cart: cart)
      end
    end
  end
end
