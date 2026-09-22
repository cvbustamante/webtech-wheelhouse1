class Bike < ApplicationRecord
  belongs_to :bike_model
  has_many :repairs, dependent: :restrict_with_error

  validates :serial_number, presence: true, uniqueness: true

  before_validation :normalize_serial_number

  scope :by_serial_number, -> { order(:serial_number) }

  private

  def normalize_serial_number
    self.serial_number = serial_number.to_s.strip.upcase
  end
end
