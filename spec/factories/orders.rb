# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user
    cart

    txtref { 'radafa' }
    status { Order.statuses.keys.sample }
    archived { [true, false].sample }
  end
end
