# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# db/seeds.rb

# unless EventUser.exists?(email: 'admin@jjrsf.org')
#   EventUser.create!(
#     name: 'Admin',
#     email: 'admin@jjrsf.org',
#     password: 'securepassword123',
#     password_confirmation: 'securepassword123',
#     role: 'admin_user'
#   )
#   puts "Admin user created."
# else
#   puts "Admin user already exists."
# end


# === Admin User ===
admin_email = 'admin@jjrsf.org'
unless EventUser.exists?(email: 'admin@jjrsf.org')
  admin = EventUser.find_or_create_by!(email: admin_email) do |user|
    user.name = 'Admin'
    user.password = 'securepassword123'
    user.password_confirmation = 'securepassword123'
    user.role = 'admin_user'
  end
  puts "✔️ Admin user ensured."
end
  
  # === Foundation Event ===
# === Admin User ===
admin_email = 'admin@jjrsf.org'
admin = EventUser.find_or_create_by!(email: admin_email) do |user|
  user.name = 'Admin'
  user.password = 'securepassword123'
  user.password_confirmation = 'securepassword123'
  user.role = 'admin_user'
end
puts "✔️ Admin user ensured."

# === Foundation Event ===
unless FoundationEvent.exists?(unique_id: 'EVT001-SAMPLE')
  FoundationEvent.create!(
    unique_id: 'EVT001-SAMPLE',
    name: 'JJRSF Annual Conference',
    start_date: Date.today,
    end_date: Date.today + 1,
    description: 'A sample event for testing.',
    online: true,
    onsite: true,
    location: 'Lagos, Nigeria',
    registration_deadline: Date.today + 7,
    evaluation: 'initial',
    image_url: 'https://via.placeholder.com/300x200.png?text=Event+Image',
    status: 'upcoming',
    event_user: admin # make sure this is available and created above
  )
  puts "✔️ Event created: JJRSF Annual Conference"
end

# event = FoundationEvent.find_by!(unique_id: 'EVT001-SAMPLE')

  
  # === Event Attendees ===
  (1..5).each do |i|
    email = "attendee#{i}@example.com"
    unless EventAttendee.exists?(email: email)
    EventAttendee.find_or_create_by!(email: email, foundation_event_id: event.id) do |a|
      a.name = "Attendee #{i}"
      a.address = "Sample Address #{i}"
      a.whatsapp = "+23480000000#{i}"
      a.phone = "0800000000#{i}"
      a.gender = %w[m f].sample
      a.member = [true, false].sample
      a.preferred_attendance = %w[Online Offline].sample
      a.otp = SecureRandom.hex(3)
    end
  end
  end
  puts "✔️ 5 attendees ensured."
  
  # === Front Desk Agents ===
  [
    { name: 'Front Desk Agent 1', pin: 'FD1001' },
    { name: 'Front Desk Agent 2', pin: 'FD1002' }
  ].each do |fd|
    unless EventFrontDesk.exists?(pin: fd[:pin])
    front_desk = EventFrontDesk.find_or_create_by(pin: fd[:pin])
    
    unless front_desk && front_desk.foundation_event_id == event.id
      EventFrontDesk.create!(
        name: fd[:name],
        pin: fd[:pin],
        foundation_event_id: event.id
      )
    end
  end
  end
  
  puts "✔️ 2 front desk agents ensured."

