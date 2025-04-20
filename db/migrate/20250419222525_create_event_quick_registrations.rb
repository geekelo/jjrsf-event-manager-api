class CreateEventQuickRegistrations < ActiveRecord::Migration[7.2]
  def up
    create_table :event_quick_registrations, id: :uuid do |t|
      t.string :name, null: true
      t.string :email, null: true
      t.string :phone, null: true
      t.string :gender, null: true  # 'm' or 'f' (optional constraint can be added later)
      t.string :otp, null: false
      t.boolean :attended_online, default: false
      t.boolean :attended_offline, default: false
      t.boolean :verified, default: false
      
      t.references :foundation_event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :event_quick_registrations
  end
end
