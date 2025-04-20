class CreateEventNotes < ActiveRecord::Migration[7.2]
  def up
    create_table :event_notes, id: :uuid do |t|
      t.text :content, null: false
      t.string :admin_name, null: false

      t.references :event_attendee, null: true, foreign_key: true, type: :uuid
      t.references :event_quick_registration, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :event_notes
  end
end
