class EventFrontDeskSerializer < ActiveModel::Serializer
  attributes :id, :name, :pin, :created_at, :updated_at
end
