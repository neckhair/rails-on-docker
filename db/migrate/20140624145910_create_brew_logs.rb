class CreateBrewLogs < ActiveRecord::Migration
  def change
    create_table :brew_logs do |t|
      t.belongs_to :brand, index: true
      t.integer :count
      t.integer :time

      t.timestamps
    end
  end
end
