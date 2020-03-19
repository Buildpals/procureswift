
FactoryBot.define do
  factory :product do
    item_url { 'https://www.amazon.com/Sony-Noise-Cancelling-Headphones-WH1000XM3/dp/B07G4MNFS1/ref=br_msw_pdt-13?_encoding=UTF8&smid=ATVPDKIKX0DER&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=&pf_rd_r=R6625NYYBDMBFYGBHEW7&pf_rd_t=36701&pf_rd_p=7e677bdf-d1ce-499a-8af2-d14952e2223b&pf_rd_i=desktop' }
    price { 348 }
    title { 'Sony Noise Cancelling Headphones WH1000XM3: Wireless Bluetooth Over the Ear Headphones with Mic and Alexa voice control - Industry Leading Active Noise Cancellation - Black' }
    weight { 0.56 }
    width { 7.31 }
    length { 10.44 }
  end
end