class EventAttendee < ApplicationRecord
  belongs_to :foundation_event

  before_validation :generate_unique_otp, on: :create

  private

  def generate_unique_otp
    return if self.otp.present?

    loop do
      self.otp = SecureRandom.hex(3) # 6-character alphanumeric lowercase
      break unless EventAttendee.exists?(otp: self.otp)
    end
  end
end