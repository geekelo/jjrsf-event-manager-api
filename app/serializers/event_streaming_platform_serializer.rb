class EventStreamingPlatformSerializer < ActiveModel::Serializer
  attributes :id, :platform_name, :embed_code, :embed_link, :visit_link, :foundation_event_id, :created_at, :updated_at
end
