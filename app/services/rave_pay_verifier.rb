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
    Rails.logger.info "Checking if txref #{transaction_reference} exists on ravepay..."
    header = { 'Content-Type': 'application/json' }
    payload = {
      'SECKEY' => @merchant_secret_key,
      'txref' => transaction_reference
    }

    http = Net::HTTP.new(@uri.host)
    request = Net::HTTP::Post.new(@uri.request_uri, header)
    request.body = payload.to_json

    response = http.request(request)
    body = JSON.parse(response.body)

    if body['data'] && body['data']['status'] == 'successful' && body['data']['chargecode'] == '00'
      Rails.logger.info 'Txref exists on Ravepay!'
    else
      Rails.logger.warn 'Txref does not exist on Ravepay!'
      return false
    end

    Rails.logger.info 'Checking if order amount tallies with transaction amount on ravepay...'
    if amounts_tally?(body)
      Rails.logger.info 'Order amount is equal to transaction amount on ravepay!'
      return true
    else
      Rails.logger.warn 'Order amount does not tally with transaction amount on ravepay!'
      byebug
      Rails.logger.warn "#{body['data']['amount']} #{ApplicationController.helpers.dollar_to_cedi(ShippingCalculator.new(@cart).order_total).floor}"
      return false
    end
  rescue Net::OpenTimeout, SocketError
    false
  end

  private

  def amounts_tally?(body)
    body['data']['amount'] == ApplicationController.helpers.dollar_to_cedi(ShippingCalculator.new(@cart).order_total).floor
  end
end
