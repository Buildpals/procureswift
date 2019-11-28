# frozen_string_literal: true

class Amazon
  # Return the ASIN from a URL copied and pasted by the user
  # Return false if no ASIN is found
  def self.get_asin_from_url(amazon_url)
    asin = if amazon_url.match(%r{/dp/(\w{10})(/|\Z)?})
             # /dp/B0015T963C
             Regexp.last_match(1)
           elsif amazon_url.match(%r{/dp/(\w{10})(/|\Z)})
             # /dp/B0015T963C
             Regexp.last_match(1)
           elsif amazon_url.match(%r{/gp/\w*?/(\w{10})(/|\Z)})
             # /gp/product/D0015T963C
             Regexp.last_match(1)
           elsif amazon_url.match(%r{/gp/\w*?/\w*?/(\w{10})(/|\Z)})
             # /gp/product/glance/E0015T963C
             Regexp.last_match(1)
           elsif amazon_url.match(%r{/gp/[\w-]*?/(\w{10})(/|\Z)})
             # /gp/offer-listing/F018Y23P7K
             Regexp.last_match(1)
           elsif amazon_url.match(%r{/product-reviews/(\w{10})(/|\Z)})
             # /product-reviews/G018Y23P7K
             Regexp.last_match(1)
           elsif amazon_url.match(/[?&]asin=(\w{10})(&|#|\Z)/i)
             # ?asin=H018Y23P7K
             # &ASIN=H018Y23P7K
             Regexp.last_match(1)
           else
             false
           end
  end
end
