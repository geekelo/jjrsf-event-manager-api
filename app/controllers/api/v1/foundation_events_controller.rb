class Api::V1::FoundationEventsController < ApplicationController
  before_action :authenticate_user!

  def index
    events = current_user.foundation_events
  
    # Update the status before rendering
    events.each(&:update_status_if_needed)
  
    render json: events, each_serializer: FoundationEventSerializer, status: :ok
  end  

  def create
    event = FoundationEvent.new(event_params.merge(event_user: current_user))
  
    if event.save
      render json: { message: 'Event created successfully', event: FoundationEventSerializer.new(event) }, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end  

  def update
    event = current_user.foundation_events.find_by(id: params[:id])
  
    if event.nil?
      render json: { error: 'Event not found' }, status: :not_found
      return
    end
  
    if event.update(event_updates_params)
      render json: { message: 'Event updated successfully', event: FoundationEventSerializer.new(event) }, status: :ok
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end  

  private

  def event_params
    params.require(:event).permit(:name, :description, :start_date, :end_date, :status, :online, :onsite, :location, :registration_deadline) 
  end

  def event_updates_params
    params.require(:event_updates).permit(:name, :description, :start_date, :end_date, :status, :online, :onsite, :location, :registration_deadline) 
  end
end
