require "test_helper"

require 'webmock'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include WebMock::API

  test "create event A without sign-in should redirect to sign-in page" do
    post events_url, params: {event_type: 'A'}

    assert_redirected_to new_user_session_path
  end

  test "create event B without sign-in should redirect to sign-in page" do
    post events_url, params: {event_type: 'B'}

    assert_redirected_to new_user_session_path
  end

  test "create event A for use Bob" do
    sign_in users(:bob)
    mock_iterable_success!
    post events_url, params: {event_type: 'A'}

    assert_redirected_to home_index_url
    assert_match 'Created Event A', flash[:notice]
  end

  test "create event B for bob should send email to bob" do
    sign_in users(:bob)
    mock_iterable_success!
    post events_url, params: {event_type: 'B'}

    assert_redirected_to home_index_url
    assert_match 'Created Event B and Sent an email to bob@gmail.com', flash[:notice]
  end

  test "create event B for alex should send email to alex" do
    sign_in users(:alex)
    mock_iterable_success!
    post events_url, params: {event_type: 'B'}

    assert_redirected_to home_index_url
    assert_match 'Created Event B and Sent an email to alex@gmail.com', flash[:notice]
  end


  test "create event A for use Bob when Iterable throws error should propagate the same error." do
    sign_in users(:bob)
    mock_iterable_failure!
    post events_url, params: {event_type: 'A'}

    assert_redirected_to home_index_url
    assert_match 'Failed to process Event A', flash[:notice]
  end

  test "create event B for use Bob when Iterable throws error should propagate the same error." do
    sign_in users(:bob)
    mock_iterable_failure!
    post events_url, params: {event_type: 'B'}

    assert_redirected_to home_index_url
    assert_match 'Failed to process Event B', flash[:notice]
  end

  def mock_iterable_success!
    # Resetting webmock present in main application for generating different test scenarios.
    WebMock.reset!
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


  def mock_iterable_failure!
    # Resetting webmock present in main application for generating different test scenarios.
    WebMock.reset!
    stub_request(:post, 'https://api.iterable.com/api/events/track').to_return(
      status: 503,
      body: { msg: 'Service unavailable', code: "Failed", params: {} }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    stub_request(:post, 'https://api.iterable.com/api/email/target').to_return(
      status: 503,
      body: { msg: 'Service unavailable', code: "Failed", params: {} }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

end
