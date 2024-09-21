require 'faraday'

ITERABLE_BASE_URL = "https://api.iterable.com"
API_KEY = "mockAPIKey"

class IterableHelper
  def create_event(email, event_type)
    conn = create_connection

    response = conn.post('/api/events/track') do |req|
      req.headers['x-api-key'] = API_KEY
      req.body = {
        email: email,
        eventName: event_type,
        createdAt: Time.now.to_i
    }.to_json
    end

    response
  end
  
  def send_email(email)
    conn = create_connection

    response = conn.post('/api/email/target') do |req|
      req.headers['x-api-key'] = API_KEY
      req.body = {
        recipientEmail: email
    }.to_json
    end

    response
  end

  def create_connection
    Faraday.new(url: ITERABLE_BASE_URL, headers: {'Content-Type' => 'application/json'}) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end
end
   