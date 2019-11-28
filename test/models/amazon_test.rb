require 'test_helper'

class AmazonTest < ActiveSupport::TestCase
  def test_get_asin_from_url
    url = "https://www.amazon.com/RUNMUS-Surround-Canceling-Compatible-Controller/dp/B07GRM747Y?pf_rd_p=1f552c7a-1af2-4608-bc6f-ba06ca3c43ac&pd_rd_wg=GM6wh&pf_rd_r=H4CXHSTS72MJ9RZKFC42&ref_=pd_gw_unk&pd_rd_w=Lbs6F&pd_rd_r=b8b3560b-3f09-4b06-b377-f7e19263c766"
    asin = "B07GRM747Y"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "https://smile.amazon.com/Programmable-Touchscreen-Thermostat-Geofencing-HomeKit/dp/A01LTHM8LG/ref=s9u_simh_gw_i1?_encoding=UTF8&fpl=fresh&pd_rd_i=B01LTHM8LG&pd_rd_r=21CHQY4CPXGGXZ5G3Q71&pd_rd_w=imw1F&pd_rd_wg=CNLFs&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=desktop-1&pf_rd_r=XDXMZR4E839F0JD45S0F&pf_rd_r=XDXMZR4E839F0JD45S0F&pf_rd_t=36701&pf_rd_p=781f4767-b4d4-466b-8c26-2639359664eb&pf_rd_p=781f4767-b4d4-466b-8c26-2639359664eb&pf_rd_i=desktop"
    asin = "A01LTHM8LG"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "http://www.amazon.com/Kindle-Wireless-Reading-Display-Generation/dp/B0015T963C"
    asin = "B0015T963C"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "http://www.amazon.com/dp/C0015T963C"
    asin = "C0015T963C"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "http://www.amazon.com/gp/product/D0015T963C"
    asin = "D0015T963C"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "http://www.amazon.com/gp/product/glance/E0015T963C"
    asin = "E0015T963C"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "https://smile.amazon.com/gp/offer-listing/F018Y23P7K/ref=dp_olp_all_mbc?ie=UTF8&condition=all"
    asin = "F018Y23P7K"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "https://smile.amazon.com/product-reviews/G018Y23P7K/ref=acr_offerlistingpage_text?ie=UTF8&reviewerType=avp_only_reviews&showViewpoints=1"
    asin = "G018Y23P7K"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "https://smile.amazon.com/forum/-/Tx3FTP6XCFXMJAO/ref=ask_dp_dpmw_al_hza?asin=H018Y23P7K"
    asin = "H018Y23P7K"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "https://smile.amazon.com/gp/customer-reviews/R1VKN59YMEK5PC/ref=cm_cr_arp_d_viewpnt?ie=UTF8&ASIN=I018Y23P7K#R1VKN59YMEK5PC"
    asin = "I018Y23P7K"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "https://smile.amazon.com/Korean-Made-Simple-beginners-learning/dp/1497445825/ref=sr_1_1?ie=UTF8&qid=1493580746&sr=8-1&keywords=korean+made+simple"
    asin = "1497445825"
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin

    url = "http://stackoverflow.com/questions/1764605/scrape-asin-from-amazon-url-using-javascript"
    asin = false
    calculated_asin = Amazon.get_asin_from_url(url)
    assert_equal asin, calculated_asin
  end
end