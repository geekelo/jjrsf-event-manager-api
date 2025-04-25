class Api::V1::EventFrontDesksController < ApplicationController
  before_action :authenticate_user!, except: [:authenticate_front_desk]
  before_action :set_event, except: [:authenticate_front_desk]
  before_action :set_front_desk, only: [:update, :destroy]

  def index
    front_desks = @event.event_front_desks
    render json: front_desks, each_serializer: EventFrontDeskSerializer, status: :ok
  end

  def create
    front_desk = @event.event_front_desks.new(front_desk_params)

    if front_desk.save
      render json: { message: 'Front desk created successfully', front_desk: EventFrontDeskSerializer.new(front_desk) }, status: :created
    else
      render json: { errors: front_desk.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event_front_desk.update(front_desk_params)
      render json: { message: 'Front desk updated successfully', front_desk: EventFrontDeskSerializer.new(@event_front_desk) }, status: :ok
    else
      render json: { errors: @event_front_desk.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @event_front_desk.destroy
      render json: { message: 'Front desk deleted successfully' }, status: :ok
    else
      render json: { errors: @event_front_desk.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def authenticate_front_desk
    event = FoundationEvent.find_by(unique_id: params[:unique_id])
    if event.nil?
      render json: { error: 'Event not found' }, status: :not_found
      return
    end

    front_desk = event.event_front_desks.find_by(pin: params[:passcode])
    if front_desk.nil?
      render json: { error: 'Invalid PIN' }, status: :unauthorized
      return
    end
    render json: { message: 'Front desk authenticated successfully', front_desk: EventFrontDeskSerializer.new(front_desk) }, status: :ok
  end

  private

  def set_front_desk
    @event_front_desk = @event.event_front_desks.find_by(id: params[:id])
    return render json: { error: 'Front desk not found' }, status: :not_found unless @event_front_desk
  end
  
  def front_desk_params
    params.require(:event_front_desk).permit(:name)
  end
end
