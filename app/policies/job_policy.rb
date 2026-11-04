# los services: la lista y la pagina de cada uno son publicas, el resto solo el owner
class JobPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
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
      scope.all
    end
  end
end
