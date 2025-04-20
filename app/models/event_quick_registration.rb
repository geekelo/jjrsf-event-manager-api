class EventQuickRegistration < ApplicationRecord
  belongs_to :foundation_event
  has_many :event_notes, dependent: :destroy
  before_validation :generate_unique_otp, on: :create

  private

  def generate_unique_otp
    return if self.otp.present?

    loop do
      self.otp = SecureRandom.hex(3) # 6-character alphanumeric lowercase
      break unless EventQuickRegistration.exists?(otp: self.otp)
    end
  end
end
