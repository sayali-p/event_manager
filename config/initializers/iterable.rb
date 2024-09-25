

require 'webmock'

ITERABLE_CONFIG = YAML.load_file(Rails.root.join('config', 'iterable.yml'))

if ITERABLE_CONFIG["use_iterable_mock"]
  include WebMock::API

  WebMock.enable!
  WebMock.disable_net_connect!(allow_localhost: true)
  # Over-the-wire mocking, TODO: move this code to separate initialiser.
  stub_request(:post, 'https://api.iterable.com/api/events/track').to_return(
  status: 200,
  body: { msg: 'Event created successfully', code: "Success", params: {} }.to_json,
  headers: { 'Content-Type' => 'application/json' }
  )

  stub_request(:post, 'https://api.iterable.com/api/email/target').to_return(
  status: 200,
  body: { msg: 'Email sent successfully', code: "Success", params: {} }.to_json,
  headers: { 'Content-Type' => 'application/json' }
  )
end