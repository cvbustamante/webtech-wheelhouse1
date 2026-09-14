class Bike < ApplicationRecord
  belongs_to :bike_model
  has_many :repairs
end
