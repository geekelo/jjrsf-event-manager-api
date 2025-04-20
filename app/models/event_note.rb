class EventNote < ApplicationRecord
  belongs_to :event_attendee, optional: true
  belongs_to :event_quick_registration, optional: true
end
