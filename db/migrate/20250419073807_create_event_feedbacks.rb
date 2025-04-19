class CreateEventFeedbacks < ActiveRecord::Migration[7.2]
  def up
    create_table :event_feedbacks, id: :uuid do |t|
      t.text :testimony, null: true
      t.text :review, null: true
      t.string :name, null: true, default: 'Anonymous'
      t.references :foundation_event, type: :uuid, foreign_key: true, null: false

      t.timestamps
    end
  end

  def down
    drop_table :event_feedbacks
  end
end
