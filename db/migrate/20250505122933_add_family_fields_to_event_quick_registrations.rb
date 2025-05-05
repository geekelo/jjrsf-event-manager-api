class AddFamilyFieldsToEventQuickRegistrations < ActiveRecord::Migration[7.2]
  def up
    add_column :event_quick_registrations, :family, :boolean, default: false
    add_column :event_quick_registrations, :family_members, :string, array: true, default: []
  end

  def down
    remove_column :event_quick_registrations, :family
    remove_column :event_quick_registrations, :family_members
  end
end
