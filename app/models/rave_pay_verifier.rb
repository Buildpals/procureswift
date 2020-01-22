# frozen_string_literal: true

class RavePayVerifier
  require 'net/http'
  require 'uri'
  require 'json'

  def initialize(cart)
    @cart = cart

    if Rails.env.production?
      @uri = URI.parse('https://api.ravepay.co/flwv3-pug/getpaidx/api/v2/verify')
      @merchant_secret_key = Rails.application.credentials.config[:ravepay][:live][:secret_key]
    else
      @uri = URI.parse('https://ravesandboxapi.flutterwave.com/flwv3-pug/getpaidx/api/v2/verify')
      @merchant_secret_key = Rails.application.credentials.config[:ravepay][:test][:secret_key]
    end
  end

  def paid?(transaction_reference)
    header = {'Content-Type': 'application/json'}
    payload = {
      'SECKEY' => @merchant_secret_key,
      'txref' => transaction_reference
    }

    http = Net::HTTP.new(@uri.host)
    request = Net::HTTP::Post.new(@uri.request_uri, header)
    request.body = payload.to_json

    response = http.request(request)
    body = JSON.parse(response.body)

    unless body['data'] && body['data']['status'] == 'successful' && body['data']['chargecode'] == '00'
      return false
    end

    body['data']['amount'] == ApplicationController.helpers.dollar_to_cedi(@cart.order_total).round
  rescue Net::OpenTimeout, SocketError
    false
  end
end
