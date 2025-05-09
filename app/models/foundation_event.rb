# app/models/foundation_event.rb

class FoundationEvent < ApplicationRecord
  belongs_to :event_user
  has_many :event_streaming_platforms, dependent: :destroy
  has_many :event_front_desks, dependent: :destroy
  has_many :event_attendees, dependent: :destroy
  has_many :event_feedbacks, dependent: :destroy
  has_many :event_quick_registrations, dependent: :destroy

  before_validation :generate_unique_id, on: :create
  before_validation :set_default_image_url, on: :create
  validates :unique_id, uniqueness: true

  def update_status_if_needed
    today = Date.today
    time_now = Time.now

    if end_date == today && end_time < time_now
      update_column(:status, 'ongoing') unless status == 'completed'
    elsif end_date == today && end_time > time_now
      update_column(:status, 'ongoing') unless status == 'ongoing'
    elsif start_date == today && start_time <= time_now
      update_column(:status, 'completed') unless status == 'ongoing'
    elsif end_date < today
      update_column(:status, 'completed') unless status == 'completed'
    else
      update_column(:status, 'upcoming') unless status == 'upcoming'
    end
  end

  def update_registration_deadline_if_needed
    today = Date.today
    time_now = Time.now

    if registration_deadline == today && registration_deadline_time > time_now
      update_column(:registration_deadline_status, 'open') unless registration_deadline_status == 'open'
    elsif registration_deadline == today && registration_deadline_time <= time_now
      update_column(:registration_deadline_status, 'closed') unless registration_deadline_status == 'closed'
    elsif registration_deadline < today 
      update_column(:registration_deadline_status, 'closed') unless registration_deadline_status == 'closed'
    else
      update_column(:registration_deadline_status, 'open') unless registration_deadline_status == 'open'
    end
  end

  private

  def generate_unique_id
    loop do
      token = Array.new(8) { [*'a'..'z', *'0'..'9'].sample }.join
      unless self.class.exists?(unique_id: token)
        self.unique_id = token
        break
      end
    end
  end 
  
  def set_default_image_url
    self.image_url ||= 'https://i.imgur.com/48O76J4.png'
  end
end
  