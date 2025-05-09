class FoundationEventSerializer < ActiveModel::Serializer
  attributes :id, :unique_id, :name, :description, :start_date, :start_time, :end_date, :end_time, :online, :onsite, :location, :status,
  :registration_deadline, :registration_deadline_time, :registration_deadline_status, :evaluation, :visibility, :image_url, :created_at, :updated_at

  def start_time
    object.start_time.strftime('%H:%M') if object.start_time
  end

  def end_time
    object.end_time.strftime('%H:%M') if object.end_time
  end

  def registration_deadline_time
    object.registration_deadline_time.strftime('%H:%M') if object.registration_deadline_time
  end
end
