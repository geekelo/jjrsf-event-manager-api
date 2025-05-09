class AddTimesAndStatusToFoundationEvents < ActiveRecord::Migration[7.2]
  def up
    add_column :foundation_events, :start_time, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :foundation_events, :end_time, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :foundation_events, :registration_deadline_time, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :foundation_events, :registration_deadline_status, :string, null: false, default: 'open'
  end

  def down
    remove_column :foundation_events, :start_time
    remove_column :foundation_events, :end_time
    remove_column :foundation_events, :registration_deadline_time
    remove_column :foundation_events, :registration_deadline_status
  end
end
