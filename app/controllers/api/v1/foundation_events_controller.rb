class Api::V1::FoundationEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:update]

  def index
    events = current_user.foundation_events
  
    # Update the status before rendering
    events.each(&:update_status_if_needed)
  
    render json: events, each_serializer: FoundationEventSerializer, status: :ok
  end

  def create
    event = current_user.foundation_events.new(event_params)
    if event.save
      render json: { message: 'Event created successfully', event: FoundationEventSerializer.new(event) }, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end  

  def update
    if @event.update(event_params)
      render json: { message: 'Event updated successfully', event: FoundationEventSerializer.new(@event) }, status: :ok
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :start_date, :end_date, :status, :online, :onsite, :location, :evaluation, :registration_deadline) 
  end
end
