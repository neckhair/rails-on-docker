class BrewLog < ActiveRecord::Base
  belongs_to :brand
  delegate :name, to: :brand, prefix: true
end
