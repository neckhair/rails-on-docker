class Brewing < ActiveRecord::Migration
  def change
    change_table :brands do |t|
      t.integer :time_to_brew, default: 10
      t.integer :in_store, default: 0
    end
  end
end
