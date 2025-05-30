class Api::V1:: SendEmailsController < ApplicationController
  before_action :authenticate_user!, except: [:publicity_email]
  before_action :set_event, except: [:publicity_email]
  before_action :set_attendee, only: [:direct_email], except: [:publicity_email]

  def direct_email
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
                when 'hybrid'
                  @event.event_attendees.where(attended_online: true).or(@event.event_attendees.where(attended_offline: true)) +
                    @event.event_quick_registrations.where(attended_online: true).or(@event.event_quick_registrations.where(attended_offline: true))
                when 'not_attended'
                  @event.event_attendees.where(attended_online: false, attended_offline: false) +
                    @event.event_quick_registrations.where(attended_online: false, attended_offline: false)
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

  def publicity_email
    # Combine both attendee sources, removing nils and duplicates by email
    unique_attendees = (EventAttendee.all + EventQuickRegistration.all)
                         .compact
                         .select { |att| att.email.present? }
                         .uniq { |att| att.email.downcase }
  
    # Send email to each attendee
    unique_attendees.each do |attendee|
      AttendeeMailer.publicity_email(attendee, email_params[:subject], email_params[:body]).deliver_now
    end
  
    render json: { message: "Emails sent to #{unique_attendees.size} unique attendees." }, status: :ok
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
