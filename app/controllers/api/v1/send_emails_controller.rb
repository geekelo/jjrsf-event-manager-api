class Api::V1:: SendEmailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :set_attendee, only: [:direct_email]

  def direct_email
    if @attendee.nil?
      render json: { error: 'Attendee not found' }, status: :not_found
      return
    end

    email = @attendee.event_emails.new(email_params)

    AttendeeMailer.direct_email(@attendee, email_params[:subject], email_params[:body], @event).deliver_now
    render json: { message: 'Email sent successfully' }, status: :ok
  end

  def bulk_email
    # Filter attendees based on attendance mode
    attendees = case params[:mode]
                when 'online'
                  @event.event_attendees.where(attended_online: true) +
                    @event.event_quick_registrations.where(attended_online: true)
                when 'offline'
                  @event.event_attendees.where(attended_offline: true) +
                    @event.event_quick_registrations.where(attended_offline: true)
                else
                  @event.event_attendees + @event.event_quick_registrations
                end
  
    # Return an error if no attendees found
    if attendees.empty?
      render json: { error: 'No attendees found' }, status: :not_found
      return
    end
  
    # Send email to each attendee
    attendees.each do |attendee|
      AttendeeMailer.bulk_email(attendee, email_params[:subject], email_params[:body], @event).deliver_now
    end
  
    render json: { message: 'Bulk emails sent successfully' }, status: :ok
  end

  private

  def set_attendee
    @attendee = @event.event_attendees.find_by(id: params[:event_attendee_id]) || 
                @event.event_quick_registrations.find_by(id: params[:event_attendee_id])
    return render json: { error: 'Attendee not found' }, status: :not_found unless @attendee
  end

  def email_params
    params.require(:event_email).permit(
      :subject,
      :body
    )
  end
end
