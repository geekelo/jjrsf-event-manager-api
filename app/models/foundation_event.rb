# app/models/foundation_event.rb

class FoundationEvent < ApplicationRecord
  belongs_to :event_user
  has_many :event_streaming_platforms, dependent: :destroy
  has_many :event_front_desks, dependent: :destroy

  before_validation :generate_unique_id, on: :create
  before_validation :set_default_image_url, on: :create
  validates :unique_id, uniqueness: true

  def update_status_if_needed
    today = Date.today

    if start_date <= today && end_date >= today
      update_column(:status, 'ongoing') unless status == 'ongoing'
    elsif end_date < today
      update_column(:status, 'completed') unless status == 'completed'
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
  