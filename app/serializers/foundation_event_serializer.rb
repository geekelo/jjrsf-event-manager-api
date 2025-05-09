class FoundationEventSerializer < ActiveModel::Serializer
  attributes :id, :unique_id, :name, :description, :start_date, :start_time, :end_date, :end_time, :online, :onsite, :location, :status,
  :registration_deadline, :registration_deadline_time, :registration_deadline_status, :evaluation, :visibility, :image_url, :created_at, :updated_at

end
