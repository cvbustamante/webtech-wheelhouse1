class Repair < ApplicationRecord
  belongs_to :bike
  belongs_to :customer
  belongs_to :mechanic, class_name: "StaffMember", optional: true
  has_many :repair_jobs, dependent: :destroy
  has_many :jobs, through: :repair_jobs

  enum :status, {
    dropped_off: "dropped_off",
    diagnosed: "diagnosed",
    waiting_for_approval: "waiting_for_approval",
    in_progress: "in_progress",
    ready: "ready",
    picked_up: "picked_up",
    declined: "declined"
  }

  validates :status, presence: true
  validates :promised_on, presence: true
  validate :dates_are_not_before_drop_off
  validate :status_matches_progress

  scope :open, -> { where(picked_up_at: nil) }
  scope :overdue, -> { open.where("promised_on < ?", Date.current) }
  scope :by_promised_on, -> { order(:promised_on) }

  def overdue?
    picked_up_at.nil? && promised_on.present? && promised_on < Date.current
  end

  def total
    repair_jobs.sum(:price_charged)
  end

  private

  def dates_are_not_before_drop_off
    return if created_at.nil?

    if promised_on.present? && promised_on < created_at.to_date
      errors.add(:promised_on, "cannot be before the day the repair came in")
    end

    if picked_up_at.present? && picked_up_at < created_at
      errors.add(:picked_up_at, "cannot be before the day the repair came in")
    end
  end

  def status_matches_progress
    if picked_up_at.present? && !picked_up?
      errors.add(:picked_up_at, "cannot be set unless the repair has been picked up")
    end

    if quoted? && repair_jobs.empty?
      errors.add(:base, "needs at least one service before reaching this status")
    end
  end

  def quoted?
    waiting_for_approval? || in_progress? || ready? || picked_up? || declined?
  end
end
