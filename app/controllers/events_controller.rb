require 'iterable_helper'
class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    event_type = params[:event_type]
    iterable = IterableHelper.new

    event_processed_response = {
      'A': 'Created Event A',
      'B': "Created Event B and Sent an email to #{current_user.email}"
  }.with_indifferent_access

    # Create event if it's type is 'A' or 'B'
    if event_type == 'A' or event_type == 'B'
      response = iterable.create_event(current_user.email, params[:event_type])
    end

    # Send email only if event is already created.
    if event_type == 'B' and response.status == 200
      response = iterable.send_email(current_user.email)
    end

    if response.status == 200
      flash[:notice] = event_processed_response[event_type]
      redirect_to home_index_url
    else
      flash[:notice] = "Failed to processed #{event_type}"
      redirect_to home_index_url
    end
  end
end
