class EventFrontDesk < ApplicationRecord
  belongs_to :foundation_event

  validates :pin, uniqueness: true

  before_validation :generate_unique_pin, on: :create

  private

  def generate_unique_pin
    return if self.pin.present?

    loop do
      self.pin = SecureRandom.hex(3) # 6-character alphanumeric lowercase
      break unless EventFrontDesk.exists?(pin: self.pin)
    end
  end
end
