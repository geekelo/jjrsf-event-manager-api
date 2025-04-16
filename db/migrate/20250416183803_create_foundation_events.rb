class CreateFoundationEvents < ActiveRecord::Migration[7.2]
  def up
    create_table :foundation_events, id: :uuid do |t|
      t.string  :unique_id, null: false, index: { unique: true }
      t.string  :name, null: false
      t.date    :start_date, null: false
      t.date    :end_date, null: false
      t.text    :description, null: false
      t.boolean  :online, null: false, default: true 
      t.boolean  :onsite, null: false, default: true 
      t.string  :location, null: true
      t.date    :registration_deadline, null: false
      t.string :evaluation, null: true
      t.string  :image_url, null: false
      t.string  :status, null: false, default: 'upcoming' # e.g., 'upcoming', 'ongoing', 'completed'

      t.references :event_user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :foundation_events
  end
end
