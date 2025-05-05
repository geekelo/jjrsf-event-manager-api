class EventAttendeeSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :address,
             :email,
             :whatsapp,
             :phone,
             :gender,
             :member,
             :preferred_attendance,
             :attended_online,
             :attended_offline,
             :otp,
             :notes,
             :family,
             :family_members,
             :foundation_event_id,
             :created_at,
             :updated_at

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end

  def updated_at
    object.updated_at.strftime('%Y-%m-%d %H:%M:%S')
  end

  def notes
    object.event_notes.map do |note|
      {
        id: note.id,
        admin_name: note.admin_name,
        content: note.content,
        created_at: note.created_at.strftime('%Y-%m-%d %H:%M:%S'),
        updated_at: note.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      }
    end
  end
end

