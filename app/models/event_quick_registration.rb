class EventQuickRegistration < ApplicationRecord
  belongs_to :foundation_event
  has_many :event_notes, dependent: :destroy
  before_validation :generate_unique_otp, on: :create

  private

  def generate_unique_otp
    return if self.otp.present?
  
    loop do
      letters = Array('a'..'z').sample(3).join
      digits = rand(100..999).to_s
      self.otp = "#{letters}#{digits}"
      break unless EventAttendee.exists?(otp: self.otp)
    end
  end  
end
