# db/migrate/20250418123456_create_event_front_desks.rb
class CreateEventFrontDesks < ActiveRecord::Migration[7.2]
  def up
    create_table :event_front_desks, id: :uuid do |t|
      t.string :name, null: false
      t.string :pin, null: false
      t.references :foundation_event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :event_front_desks, :pin, unique: true
  end

  def down
    remove_index :event_front_desks, :pin
    drop_table :event_front_desks
  end
end
