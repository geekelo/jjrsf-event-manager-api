class CreateEventStreamingPlatforms < ActiveRecord::Migration[7.2]
  def change
    create_table :event_streaming_platforms, id: :uuid do |t|
      t.string :platform_name, null: false
      t.text :embed_code
      t.string :embed_link
      t.string :visit_link

      t.references :foundation_event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
