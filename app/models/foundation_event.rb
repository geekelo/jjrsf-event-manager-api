# app/models/foundation_event.rb

class FoundationEvent < ApplicationRecord
  belongs_to :event_user
  before_validation :generate_unique_id, on: :create
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
end
  