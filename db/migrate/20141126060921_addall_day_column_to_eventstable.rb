class AddallDayColumnToEventstable < ActiveRecord::Migration
  def change
    add_column :events, :all_day, :boolean, :default => true
  end
end
