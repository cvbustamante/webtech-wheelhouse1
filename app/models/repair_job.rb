class RepairJob < ApplicationRecord
  belongs_to :repair
  belongs_to :job

  validates :price_charged, presence: true, numericality: { greater_than: 0 }
end
