class TripSupply < ActiveRecord::Base
  belongs_to :trip
  belongs_to :supply
end