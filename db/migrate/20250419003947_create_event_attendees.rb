# db/migrate/20250418130000_create_event_attendees.rb
class CreateEventAttendees < ActiveRecord::Migration[7.2]
  def up
    create_table :event_attendees, id: :uuid do |t|
      t.string :name, null: false
      t.string :address
      t.string :email
      t.string :whatsapp
      t.string :phone
      t.string :gender  # 'f' or 'm'
      t.boolean :member, default: false
      t.string :preferred_attendance  # "Online" or "Offline"
      t.boolean :attended_online, default: false
      t.boolean :attended_offline, default: false
      t.string :otp, null: false
      t.references :foundation_event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :event_attendees, :otp, unique: true
    add_index :event_attendees, :email
  end

  def down
    remove_index :event_attendees, :otp
    remove_index :event_attendees, :email
    drop_table :event_attendees
  end
end
