class BikeModel < ApplicationRecord
  has_many :bikes, dependent: :restrict_with_error

  validates :name, presence: true
end
