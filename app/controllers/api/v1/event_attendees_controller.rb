class EventAttendeesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :update]
  before_action :set_event, only: [:index, :create]
  before_action :set_attendee, only: [:update]

  def index
    attendees = @event.event_attendees

    render json: attendees, each_serializer: EventAttendeeSerializer, status: :ok
  end

  def create
    event = FoundationEvent.find(params[:event_id])

    if event.nil?
      render json: { error: 'Event not found' }, status: :not_found
      return
    end
    if event.registration_deadline.past?
      render json: { error: 'Registration deadline has passed' }, status: :unprocessable_entity
      return
    end
    attendee = event.event_attendees.new(attendee_params)

    if attendee.save
      render json: { message: 'You have successfully registered', attendee: EventAttendeeSerializer.new(attendee) }, status: :created
    else
      render json: { errors: attendee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @attendee.update(attendee_params)
      render json: { message: 'Attendee updated successfully', attendee: EventAttendeeSerializer.new(@attendee) }, status: :ok
    else
      render json: { errors: attendee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def set_attendee
    @attendee = @event.event_attendees.find_by(id: params[:id])
    return render json: { error: 'Attendee not found' }, status: :not_found unless @attendee
  end

  def attendee_params
    params.require(:event_attendee).permit(
      :name,
      :address,
      :email,
      :whatsapp,
      :phone,
      :gender,
      :member,
      :preferred_attendance,
      :attended_online,
      :attended_offline,
    )
  end
end
