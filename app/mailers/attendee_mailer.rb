class AttendeeMailer < ApplicationMailer
   default from: 'JJRSF Events Team <no-reply@yourdomain.com>'

  def registration_confirmation(attendee, event)
    @attendee = attendee
    @event = event
    mail(to: @attendee.email, subject: 'Your Event Registration Details')
  end
end
  