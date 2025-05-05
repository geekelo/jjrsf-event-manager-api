class AddFamilyFieldsToEventAttendees < ActiveRecord::Migration[7.2]
  def up
    add_column :event_attendees, :family, :boolean, default: false
    add_column :event_attendees, :family_members, :string, array: true, default: []
  end

  def down
    remove_column :event_attendees, :family
    remove_column :event_attendees, :family_members
  end
end
