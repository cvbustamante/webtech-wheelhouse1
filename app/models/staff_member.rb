class StaffMember < ApplicationRecord
  has_many :repairs, foreign_key: "mechanic_id", dependent: :nullify
  has_one :user, dependent: :restrict_with_error

  validates :name, presence: true
  validates :role, presence: true

  scope :by_name, -> { order(:name) }
end
