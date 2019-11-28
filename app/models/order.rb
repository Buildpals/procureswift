class Order < ApplicationRecord
  enum delivery_method: { by_air: 0, by_sea: 1}
  enum delivery_region: { greater_accra: 0, ashanti: 1, eastern: 2 }
end
