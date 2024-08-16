class EventsController < ApplicationController
  def index
  end

  def create
    event_type = params[:event_type]
    render json: {type: event_type}
  end
end
