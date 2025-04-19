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

unless EventUser.exists?(email: 'admin@jjrsf.org')
  EventUser.create!(
    name: 'Admin',
    email: 'admin@jjrsf.org',
    password: 'securepassword123',
    password_confirmation: 'securepassword123',
    role: 'admin_user'
  )
  puts "Admin user created."
else
  puts "Admin user already exists."
end


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
event = FoundationEvent.find_or_create_by!(unique_id: 'EVT001-SAMPLE') do |e|
  e.name = 'JJRSF Annual Conference'
  e.start_date = Date.today
  e.end_date = Date.today + 1
  e.description = 'A sample event for testing.'
  e.online = true
  e.onsite = true
  e.location = 'Lagos, Nigeria'
  e.registration_deadline = Date.today + 7
  e.evaluation = 'initial'
  e.image_url = 'https://via.placeholder.com/300x200.png?text=Event+Image'
  e.status = 'upcoming'
  e.event_user = admin
end
puts "✔️ Event ensured: #{event.name}"

# === Event Attendees ===
(1..5).each do |i|
  email = "attendee#{i}@example.com"
  attendee = EventAttendee.find_or_create_by!(email: email, foundation_event_id: event.id) do |a|
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
puts "✔️ 5 attendees ensured."

# === Front Desk Agents ===
[
  { name: 'Front Desk Agent 1', pin: 'FD1001' },
  { name: 'Front Desk Agent 2', pin: 'FD1002' }
].each do |fd|
  EventFrontDesk.find_or_create_by!(pin: fd[:pin], foundation_event_id: event.id) do |front_desk|
    front_desk.name = fd[:name]
  end
end
puts "✔️ 2 front desk agents ensured."
