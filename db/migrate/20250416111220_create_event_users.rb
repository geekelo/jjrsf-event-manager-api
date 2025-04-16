class CreateEventUsers < ActiveRecord::Migration[7.2]
  def up
    create_table :event_users, id: :uuid do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name, null: false
      t.string :password_digest, null: false # assuming you're using has_secure_password
      t.string :role, null: false, default: 'user' # e.g., roles like 'super_admin', 'admin_user', 'manager', 'staff'

      t.timestamps
    end
  end

  def down
    drop_table :event_users
  end
end
