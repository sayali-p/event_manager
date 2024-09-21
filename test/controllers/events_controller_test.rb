require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "create event A" do
    post events_url, params: {event_type: 'A'}
    assert_response :success
    assert_match '{"msg":"Successfully processed A"}', @response.body
  end

  test "create event B" do
    post events_url, params: {event_type: 'B'}
    assert_response :success
    assert_match  '{"msg":"Successfully processed B"}', @response.body
  end
end
