require 'iterable_helper'
class EventsController < ApplicationController
  def index
  end

  def create
    event_type = params[:event_type]
    iterable = IterableHelper.new

    # Create event if it's type is 'A' or 'B'
    if event_type == 'A' or event_type == 'B'
      response = iterable.create_event('xyz@gmail.com', params[:event_type])
    end

    # Send email only if event is already created.
    if event_type == 'B' and response.status == 200
      response = iterable.send_email('xyz@gmail.com')
    end

    if response.status == 200
      render json: {msg: "Successfully processed #{event_type}"}, status: :created
    else
      render json: response, status: :service_unavailable
    end
  end
end
