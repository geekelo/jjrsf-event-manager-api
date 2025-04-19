class EventFrontDeskSerializer < ActiveModel::Serializer
  attributes :id, :name, :pin, :foundation_event_id, :created_at, :updated_at
end
