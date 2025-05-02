require 'ostruct'

class AttendeeMailer < ApplicationMailer
   default from: 'JJRSF Programs Team <no-reply@yourdomain.com>'

  def registration_confirmation(attendee, event)
    @attendee = attendee
    @event = event
    mail(to: @attendee.email, subject: 'Your Program Registration Details')
  end

  def registration_notification(attendee, event)
    @attendee = normalize_attendee(attendee)
    @event = event
    mail(to: 'jjrsfoundation@gnail.com', subject: 'New Program Registration Notification')
  end

  def direct_email(attendee, subject, body, event)
    @attendee = attendee
    @subject = subject
    @body = body
    @event = event
    mail(to: @attendee.email, subject: @subject)
  end

  def bulk_email(attendee, subject, body, event)
    @attendee = attendee
    @subject = subject
    @body = body
    @event = event
    mail(to: @attendee.email, subject: @subject)
  end

  def event_reminder(attendee, event)
    @attendee = attendee
    @event = event
    mail(to: @attendee.email, subject: 'Reminder: Upcoming Program')
  end

  def publicity_email(attendee, subject, body)
    @attendee = attendee
    @subject = subject
    @body = body
    mail(to: @attendee.email, subject: @subject)
  end

  private

  def normalize_attendee(att)
    OpenStruct.new(
      name: att.name,
      email: att.email,
      phone: att.try(:phone) || att.try(:phone_number),
      whatsapp: att.try(:whatsapp) || att.try(:whatsapp_number),
      member: att.try(:member),
      otp: att.otp,
      preferred_attendance: att.try(:preferred_attendance),
      created_at: att.try(:created_at)
    )
  end
end
