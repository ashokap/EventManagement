class ChangeallDayColumnDefaultValue < ActiveRecord::Migration
 
  def change
    change_column :events, :all_day, :boolean, :default => false
  end
  
end
