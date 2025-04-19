class EventNoteSerializer < ActiveModel::Serializer
  attributes :id, :admin_name, :content, :event_attendee_id, :created_at, :updated_at

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end

  def updated_at
    object.updated_at.strftime('%Y-%m-%d %H:%M:%S')
  end

  def attendee_name
    object.event_attendee.name if object.event_attendee
  end
end
