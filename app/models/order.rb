# frozen_string_literal: true

class Order < ApplicationRecord
  require 'net/http'
  require 'uri'
  require 'json'

  has_paper_trail

  include ActionView::Helpers::NumberHelper

  belongs_to :user, inverse_of: :orders
  belongs_to :cart, inverse_of: :order

  enum status: { pending: 0, failure: 1, success: 3 }

  delegate :number_of_items,
           :subtotal,
           :shipping_and_handling,
           :duty,
           :order_total, to: :cart

  def purchased?(cart)
    if Rails.env.production?
      uri = URI.parse('https://api.ravepay.co/flwv3-pug/getpaidx/api/v2/verify')
      merchant_secret_key = Rails.application.credentials.config[:ravepay][:live][:secret_key]
    else
      uri = URI.parse('https://ravesandboxapi.flutterwave.com/flwv3-pug/getpaidx/api/v2/verify')
      merchant_secret_key = Rails.application.credentials.config[:ravepay][:test][:secret_key]
    end

    header = { 'Content-Type': 'application/json' }
    payload = {
      'SECKEY' => merchant_secret_key,
      'txref' => cart.tx_ref
    }

    http = Net::HTTP.new(uri.host)

    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = payload.to_json

    response = http.request(request)
    body = JSON.parse(response.body)

    puts '<<<<<<<<<<<<<<<<<<<<<<<<<'
    puts body
    puts body['data']['amount']
    puts cart.order_total
    puts '>>>>>>>>>>>>>>>>>>>>>>>>>'

    unless body['data'] && body['data']['status'] == 'successful' && body['data']['chargecode'] == '00'
      return false
    end

    body['data']['amount'] == cart.order_total
  rescue Net::OpenTimeout, SocketError
    false
  end
end
