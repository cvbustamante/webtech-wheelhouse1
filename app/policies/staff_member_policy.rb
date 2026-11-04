# todo el que tiene cuenta lee el staff, solo el owner lo cambia
class StaffMemberPolicy < ApplicationPolicy
  def index?
    signed_in?
  end

  def show?
    signed_in?
  end

  def new?
    owner?
  end

  def create?
    owner?
  end

  def edit?
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      user.present? ? scope.all : scope.none
    end
  end
end
