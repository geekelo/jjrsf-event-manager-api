class EventUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :role, :created_at, :updated_at
end
