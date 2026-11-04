class RepairPolicy < ApplicationPolicy
  # lo que el mecanico puede cambiar de sus repairs; el owner y el counter cambian todo
  MECHANIC_ATTRIBUTES = [:status, :diagnosis, intake_photos: []].freeze
  ALL_ATTRIBUTES = [
    :bike_id, :customer_id, :mechanic_id, :status, :promised_on, :picked_up_at, :diagnosis,
    intake_photos: [],
    repair_jobs_attributes: [[:id, :job_id, :price_charged, :_destroy]]
  ].freeze

  # el index se abre para todos, pero cada uno ve lo que le da el scope
  def index?
    signed_in?
  end

  def show?
    owner? || counter? || own_repair?
  end

  def new?
    owner? || counter?
  end

  def create?
    owner? || counter?
  end

  def edit?
    owner? || (counter? && !handed_back?) || (own_repair? && !handed_back?)
  end

  def update?
    edit?
  end

  def destroy?
    owner?
  end

  def permitted_attributes
    owner? || counter? ? ALL_ATTRIBUTES : MECHANIC_ATTRIBUTES
  end

  # para que el form muestre solo los campos que la persona puede cambiar
  def permitted_attribute?(attribute)
    permitted_attributes.any? { |a| a == attribute || (a.is_a?(Hash) && a.key?(attribute)) }
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if user.nil?
      return scope.all if user.owner? || user.counter?

      # un mecanico sin staff no tiene repairs propias
      user.staff_member_id ? scope.where(mechanic_id: user.staff_member_id) : scope.none
    end
  end

  private

  # sus repairs son las que tienen como mecanico al staff de su cuenta
  def own_repair?
    signed_in? && user.mechanic? && user.staff_member_id.present? && record.mechanic_id == user.staff_member_id
  end

  # entregada = el ultimo estado del lifecycle (docs/domain-model.md)
  def handed_back?
    record.picked_up?
  end
end
