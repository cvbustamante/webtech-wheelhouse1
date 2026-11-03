class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :staff_member, optional: true
  has_many :taken_in_repairs, class_name: "Repair", foreign_key: "taken_in_by_id", dependent: :restrict_with_error

  enum :role, {
    owner: "owner",
    mechanic: "mechanic",
    counter: "counter"
  }

  MIN_PASSWORD_LENGTH = 10

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }
  # el mensaje por defecto ya dice el minimo: "is too short (minimum is 10 characters)"
  validates :password, length: { minimum: MIN_PASSWORD_LENGTH }, allow_nil: true
  validates :role, presence: true

  # lo que se muestra en la navbar y en las repairs: el nombre del staff o el email
  def display_name
    staff_member&.name || email_address
  end
end
