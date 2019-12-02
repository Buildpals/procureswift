# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.cell_phone }
    password { Faker::Internet.password }
  end
end
