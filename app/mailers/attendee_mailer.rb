class AttendeeMailer < ApplicationMailer
   default from: 'JJRSF Events Team <no-reply@yourdomain.com>'

  def registration_confirmation(attendee)
    @attendee = attendee
    @event = attendee.foundation_events
    mail(to: @attendee.email, subject: 'Your Event Registration Details')
  end
end
  