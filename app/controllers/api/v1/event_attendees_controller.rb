class Api::V1::EventAttendeesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :update]
  before_action :set_event, only: [:index, :update]
  before_action :set_attendee, only: [:update]
  before_action :set_user_side_event, only: [:create, :mark_attendance]

  def index
    attendees = @event.event_attendees

    render json: attendees, each_serializer: EventAttendeeSerializer, status: :ok
  end

  def create
    if @user_side_event.registration_deadline.past?
      render json: { error: 'Registration deadline has passed' }, status: :unprocessable_entity
      return
    end
    attendee = @user_side_event.event_attendees.new(attendee_params)

    if attendee.save
      AttendeeMailer.registration_confirmation(attendee, @user_side_event).deliver_now
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

  def mark_attendance
    attendee = if params[:unique_id].present?
                 @user_side_event.event_attendees.find_by(unique_id: params[:unique_id])
               elsif params[:email].present?
                @user_side_event.event_attendees.find_by(email: params[:email])
               end
  
    return render json: { error: 'Unique ID or email is required' }, status: :unprocessable_entity unless attendee
  
    mode = params[:mode] # expects 'online' or 'offline'
    case mode
    when 'online'
      success = attendee.update(attended_online: true)
    when 'offline'
      success = attendee.update(attended_offline: true)
    else
      return render json: { error: 'Invalid attendance mode. Must be "online" or "offline".' }, status: :unprocessable_entity
    end

    if success
      render json: {
        message: 'Attendee marked as attended online successfully',
        attendee: EventAttendeeSerializer.new(attendee)
      }, status: :ok
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
