class EventFrontDesks < ApplicationRecord
  belongs_to :foundation_event

  validates :pin, uniqueness: true
end
