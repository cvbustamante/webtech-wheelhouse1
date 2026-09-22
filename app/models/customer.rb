class Customer < ApplicationRecord
  has_many :repairs, dependent: :restrict_with_error
  has_many :bikes, -> { distinct }, through: :repairs

  validates :name, presence: true
  validates :phone, presence: true

  scope :by_name, -> { order(:name) }
end
