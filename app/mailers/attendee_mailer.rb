class AttendeeMailer < ApplicationMailer
   default from: 'JJRSF Programs Team <no-reply@yourdomain.com>'

  def registration_confirmation(attendee, event)
    @attendee = attendee
    @event = event
    mail(to: @attendee.email, subject: 'Your Program Registration Details')
  end

  def registration_notification(attendee, event)
    @attendee = attendee
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
    mail(to: @attendee, subject: @subject)
  end
end
