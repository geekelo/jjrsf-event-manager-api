class EventAttendeesSerializer < ActiveModel::Serializer
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
             :foundation_event_id,
             :created_at,
             :updated_at
end

