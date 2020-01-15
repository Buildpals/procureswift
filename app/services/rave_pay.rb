class RavePay

  SECRET_KEY = 'FLWSECK-fc5ae2b02857b8b523dc6f53cde8fc90-X'

  PUBLIC_KEY = 'FLWPUBK-8289a3561ffe0c40c4904e20d550db77-X'

  TEST_PUBLIC_KEY = 'FLWPUBK_TEST-5d111ed01ffb9d0a9b6a0d0811ceb591-X'

  TEST_SECRET_KEY = 'FLWSECK_TEST-c7e13d86c3473c2ec33e38f2cacc6afe-X'

  TEST_URL = 'https://ravesandboxapi.flutterwave.com/flwv3-pug/getpaidx/api/v2/verify'

  LIVE_URL = 'https://api.ravepay.co/flwv3-pug/getpaidx/api/v2/verify'

  def initialize; end

  def call(txref)
    if Rails.env.development? || Rails.env.test?
      payload = {'SECKEY': TEST_SECRET_KEY, tx_ref: txref }
    else
      payload = {'SECKEY': SECRET_KEY, tx_ref: txref }
    end
    json = payload.to_json
    ActiveSupport::JSON.decode(send_request_to_rave_pay(json))
  end

  private

  def send_request_to_rave_pay(payload)
    if Rails.env.development? || Rails.env.test?
      connection = Faraday.new(TEST_URL)
    else
      connection = Faraday.new(LIVE_URL)
    end
    response = connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = payload
    end
    response.body
  end
end