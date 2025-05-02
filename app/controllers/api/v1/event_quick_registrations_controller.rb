class Api::V1::EventQuickRegistrationsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :set_event, only: [:index]
  before_action :set_user_side_event, only: [:create]
  
  def index
    quick_registrations = @event.event_quick_registrations
    render json: quick_registrations, each_serializer: EventQuickRegistrationSerializer, status: :ok
  end

  def create
    if email_already_exists?
      render json: { error: 'Email already exists' }, status: :unprocessable_entity
      return
    else
      guest = @user_side_event.event_quick_registrations.new(guest_params)
      if guest.save
        AttendeeMailer.registration_confirmation(guest, @user_side_event).deliver_now
        AttendeeMailer.registration_notification(guest, @user_side_event).deliver_now
        render json: { message: 'Guest created successfully' }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def verify_guest
    guest = EventQuickRegistration.find_by(otp: params[:otp])
    if guest
      guest.update(verified: true)
      render json: { message: 'Guest verified successfully' }, status: :ok
    else
      render json: { error: 'Invalid OTP' }, status: :unprocessable_entity
    end
  end

  private

  def guest_params
    params.require(:guest).permit(:email, :name, :phone, :gender, :attended_online, :attended_offline)
  end

  def email_already_exists?
    @user_side_event.event_attendees.exists?(email: params[:guest][:email]) ||
    @user_side_event.event_quick_registrations.exists?(email: params[:guest][:email])
  end  
end