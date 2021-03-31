class TripSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :user_id, :start_date, :end_date
  has_many :supplies
end
