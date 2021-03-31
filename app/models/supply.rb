class Supply < ActiveRecord::Base
  belongs_to :trip
  has_many :trip_supplies
  has_many :trips, :through => :trip_supplies
  validates :name, :presence => true
end