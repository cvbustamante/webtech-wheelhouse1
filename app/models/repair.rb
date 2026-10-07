class Repair < ApplicationRecord
  belongs_to :bike
  belongs_to :customer
  belongs_to :mechanic, class_name: "StaffMember", optional: true
  has_many :repair_jobs, -> { order(:id) }, dependent: :destroy
  has_many :jobs, through: :repair_jobs

  accepts_nested_attributes_for :repair_jobs,
    allow_destroy: true,
    reject_if: proc { |attrs| attrs["job_id"].blank? }

  has_many_attached :intake_photos do |attachable|
    attachable.variant :thumb, resize_to_fill: [150, 150]
    attachable.variant :large, resize_to_limit: [800, 800]
  end
  has_rich_text :diagnosis

  ALLOWED_PHOTO_TYPES = %w[image/jpeg image/png].freeze
  MAX_PHOTO_SIZE = 5.megabytes

  validate :intake_photos_are_valid

  enum :status, {
    dropped_off: "dropped_off",
    diagnosed: "diagnosed",
    waiting_for_approval: "waiting_for_approval",
    in_progress: "in_progress",
    ready: "ready",
    picked_up: "picked_up",
    declined: "declined"
  }

  # dropped_off/diagnosed son previas a pedirle una respuesta al customer:
  # de ahi no se puede saltar directo a un estado que ya supone esa respuesta
  NOT_YET_ANSWERED = %w[dropped_off diagnosed].freeze
  NEEDS_CUSTOMER_ANSWER = %w[in_progress ready picked_up declined].freeze

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
    # un repair nuevo todavia no tiene created_at (se pone recien al guardar),
    # asi que para uno nuevo el "dia que llego" es hoy
    dropped_off_on = (created_at || Time.current)

    if promised_on.present? && promised_on < dropped_off_on.to_date
      errors.add(:promised_on, "cannot be before the day the repair came in")
    end

    if picked_up_at.present? && picked_up_at < dropped_off_on
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

    if persisted? && will_save_change_to_status? &&
       NEEDS_CUSTOMER_ANSWER.include?(status) && NOT_YET_ANSWERED.include?(status_was)
      errors.add(:status, "cannot move to #{status.tr("_", " ")} before the customer answers the quote")
    end
  end

  def quoted?
    waiting_for_approval? || in_progress? || ready? || picked_up? || declined?
  end

  def intake_photos_are_valid
    intake_photos.each do |photo|
      unless ALLOWED_PHOTO_TYPES.include?(photo.content_type)
        errors.add(:intake_photos, "#{photo.filename} is not an accepted image type")
      end

      if photo.byte_size > MAX_PHOTO_SIZE
        errors.add(:intake_photos, "#{photo.filename} is too large (maximum is #{MAX_PHOTO_SIZE / 1.megabyte} MB)")
      end
    end
  end
end
