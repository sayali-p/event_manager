require 'iterable_helper'
class EventsController < ApplicationController
  def index
  end

  def create
    response = IterableHelper.new.create_event('xyz@gmail.com', params[:event_type])
    event_type = params[:event_type]
    render json: {type: event_type}
  end
end
