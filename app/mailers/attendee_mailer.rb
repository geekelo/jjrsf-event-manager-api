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
end
