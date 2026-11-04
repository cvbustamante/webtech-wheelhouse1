# el counter atiende a los customers pero no los borra; el mecanico no los ve
class CustomerPolicy < ApplicationPolicy
  def index?
    owner? || counter?
  end

  def show?
    owner? || counter?
  end

  def new?
    owner? || counter?
  end

  def create?
    owner? || counter?
  end

  def edit?
    owner? || counter?
  end

  def update?
    owner? || counter?
  end

  def destroy?
    owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      user.present? && (user.owner? || user.counter?) ? scope.all : scope.none
    end
  end
end
