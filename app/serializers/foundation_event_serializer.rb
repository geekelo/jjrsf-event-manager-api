class FoundationEventSerializer < ActiveModel::Serializer
  attributes :id, :unique_id, :name, :description, :start_date, :end_date, :online, :onsite, :location, :status,
  :registration_deadline, :evaluation, :image_url, :created_at, :updated_at

end
