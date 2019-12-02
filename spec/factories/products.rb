
FactoryBot.define do
  factory :product do
    item_url { 'https://www.amazon.com/Sony-Noise-Cancelling-Headphones-WH1000XM3/dp/B07G4MNFS1/ref=br_msw_pdt-13?_encoding=UTF8&smid=ATVPDKIKX0DER&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=&pf_rd_r=R6625NYYBDMBFYGBHEW7&pf_rd_t=36701&pf_rd_p=7e677bdf-d1ce-499a-8af2-d14952e2223b&pf_rd_i=desktop' }
    item_quantity { 1 }
    delivery_method { [0, 1].sample }
    delivery_region { [0, 1].sample }
    full_name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.cell_phone }
    zinc_product_details do
      Rack::Test::UploadedFile.new('spec/fixtures/files/zinc_product_details.json', 'text/json')
    end
    zinc_product_offers do
      Rack::Test::UploadedFile.new('spec/fixtures/files/zinc_product_offers.json', 'text/json')
    end
  end
end