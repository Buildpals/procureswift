# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    product
    user

    chosen_offer_id { 'MyString' }
    quantity { (0..20).to_a.sample }
    delivery_method { [0, 1].sample }

    full_name { Faker::Name.name }

    address { Faker::Address.street_address }
    region { (0..9).to_a.sample }
    city_or_town { Faker::Address.city }

    phone_number { Faker::PhoneNumber.cell_phone }

    email { Faker::Internet.email }
    txtref { 'MyString' }
    status { 1 }
  end
end
