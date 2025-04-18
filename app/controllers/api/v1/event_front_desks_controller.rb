class Api::V1::EventFrontDesksController < ApplicationController
  before_action :authenticate_user!

  def index
    front_desks = current_user.foundation_events.event_front_desks

    render json: front_desks, each_serializer: EventFrontDeskSerializer, status: :ok
  end

  def create
    front_desk = EventFrontDesk.new(front_desk_params)

    if front_desk.save
      render json: { message: 'Front desk created successfully', front_desk: EventFrontDeskSerializer.new(front_desk) }, status: :created
    else
      render json: { errors: front_desk.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    front_desk = current_user.foundation_events.event_front_desks.find_by(id: params[:id])
    if front_desk.nil?
        render json: { error: 'Front desk not found' }, status: :not_found
        return
    end
    # First, permit all front_desk_updates keys
    permitted_updates = params.require(:front_desk_updates).permit!
    # Then remove unwanted keys
    updates = permitted_updates.except(
        :controller,
        :action,
        :format,
        :id,
        :authenticity_token,
        :commit,
        :utf8,
        :event_user_id
    )
    if front_desk.update(updates)
      render json: { message: 'Front desk updated successfully', front_desk: EventFrontDeskSerializer.new(front_desk) }, status: :ok
    else
      render json: { errors: front_desk.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    front_desk = current_user.foundation_events.event_front_desks.find_by(id: params[:id])
    if front_desk.nil?
        render json: { error: 'Front desk not found' }, status: :not_found
        return
    end
    if front_desk.destroy
        render json: { message: 'Front desk deleted successfully', front_desks: EventFrontDeskSerializer }, status: :ok
    else
        render json: { errors: front_desk.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def front_desk_params
    params.require(:event_front_desk).permit(:name, :pin)
  end
end
