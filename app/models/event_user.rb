class EventUser < ApplicationRecord
  has_secure_password
  has_many :foundation_events, dependent: :destroy
end
