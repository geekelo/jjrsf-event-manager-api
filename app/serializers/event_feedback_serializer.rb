class EventFeedbackSerializer < ActiveModel::Serializer
  attributes :id, :testimony, :name, :review, :foundation_event_id, :created_at, :updated_at
end
