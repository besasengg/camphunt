class Trip < ActiveRecord::Base
  belongs_to :user
  has_many :trip_supplies
  has_many :supplies, :through => :trip_supplies

  validates :name, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
end