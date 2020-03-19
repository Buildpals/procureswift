# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
  c.filter_sensitive_data('<ZINC_API_CLIENT_TOKEN>') { Rails.application.credentials.config[:zincapi][:client_token] }

  c.filter_sensitive_data('<RAVE_PAY_LIVE_SECRET_KEY>') { Rails.application.credentials.config[:ravepay][:live][:secret_key] }
  c.filter_sensitive_data('<RAVE_PAY_LIVE_PUBLIC_KEY>') { Rails.application.credentials.config[:ravepay][:live][:public_key] }

  c.filter_sensitive_data('<RAVE_PAY_TEST_SECRET_KEY>') { Rails.application.credentials.config[:ravepay][:test][:secret_key] }
  c.filter_sensitive_data('<RAVE_PAY_TEST_PUBLIC_KEY>') { Rails.application.credentials.config[:ravepay][:test][:public_key] }

  driver_urls = Webdrivers::Common.subclasses.map(&:base_url)
  c.ignore_hosts(*driver_urls)
  WebMock.disable_net_connect!(allow_localhost: true, allow: driver_urls)
end
