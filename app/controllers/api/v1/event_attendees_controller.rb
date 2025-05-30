class Api::V1::EventAttendeesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :update, :notify_attendees]
  before_action :set_event, only: [:index, :update, :notify_attendees]
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

    if email_already_exists?
      render json: { error: 'Email already exists' }, status: :unprocessable_entity
      return
    end
    
    attendee = @user_side_event.event_attendees.new(attendee_params)

    if attendee.save
      AttendeeMailer.registration_confirmation(attendee, @user_side_event).deliver_now
      AttendeeMailer.registration_notification(attendee, @user_side_event).deliver_now
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
    attendee =  if params[:otp].present?
                  @user_side_event.event_attendees.find_by(otp: params[:otp]) ||
                  @user_side_event.event_quick_registrations.find_by(otp: params[:otp])
                elsif params[:email].present?
                  @user_side_event.event_attendees.find_by(email: params[:email]) ||
                  @user_side_event.event_quick_registrations.find_by(email: params[:email])
                elsif params[:name].present?
                  name_query = "%#{params[:name]}%"
                  @user_side_event.event_attendees.where('name ILIKE ?', name_query).first ||
                  @user_side_event.event_quick_registrations.where('name ILIKE ?', name_query).first                
                elsif params[:name].present?
                  @user_side_event.event_attendees.find_by(name: params[:name]) ||
                  @user_side_event.event_quick_registrations.find_by(name: params[:name])
                elsif params[:phone].present?
                  @user_side_event.event_attendees.find_by(phone: params[:phone]) ||
                  @user_side_event.event_quick_registrations.find_by(phone: params[:phone]) ||                  
                  @user_side_event.event_attendees.find_by(whatsapp: params[:phone]) ||
                  @user_side_event.event_quick_registrations.find_by(whatsapp: params[:phone])
                else
                  nil
                end
  
    return render json: { error: 'OTP or email is required' }, status: :unprocessable_entity unless attendee
  
    mode = params[:mode].to_s.downcase # expects 'online' or 'offline'

    case mode
    when 'online'
      success = attendee&.update(attended_online: true)
    when 'offline'
      success = attendee&.update(attended_offline: true)
    else
      return render json: { error: 'Invalid attendance mode. Must be "online" or "offline".' }, status: :unprocessable_entity
    end

    if success
      render json: {
        message: 'Attendee marked as attended successfully',
        attendee: EventAttendeeSerializer.new(attendee) || EventQuickRegistrationSerializer.new(attendee)
      }, status: :ok
    else
      render json: { errors: attendee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def notify_attendees
    attendees = @event.event_attendees
    attendees.each do |attendee|
      AttendeeMailer.event_reminder(attendee, @event).deliver_now
    end
    render json: { message: 'Notifications sent successfully' }, status: :ok
  end

  def unique_attendees
    unique_attendees = EventAttendee.all.uniq { |att| att.email }
    render json: unique_attendees, status: :ok
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
      :family,
      :family_members,
    )
  end

  def email_already_exists?
    return false if params[:event_attendee][:email].blank? || params[:event_attendee][:email].nil?
    
    # Check if the email already exists in the event attendees or quick registrations
    @user_side_event.event_attendees.exists?(email: params[:event_attendee][:email]) ||
    @user_side_event.event_quick_registrations.exists?(email: params[:event_attendee][:email])
  end
end
