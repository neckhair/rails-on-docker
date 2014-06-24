class Brand < ActiveRecord::Base
  validates :name, presence: true
  validates :time_to_brew, numericality: true
end
