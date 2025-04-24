class AddVisibilityToFoundationEvents < ActiveRecord::Migration[7.2]
  def up
    add_column :foundation_events, :visibility, :boolean, default: true, null: false
  end

  def down
    remove_column :foundation_events, :visibility
  end
end
