# la base no deja hacer nada: si a una policy le falta un metodo, la accion queda rechazada
class ApplicationPolicy
  attr_reader :user, :record

  # user es la cuenta de la sesion (o nil si es un visitante), la pasa el controller
  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    false
  end

  def create?
    false
  end

  def edit?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.none
    end

    private

    attr_reader :user, :scope
  end

  private

  def signed_in?
    user.present?
  end

  def owner?
    signed_in? && user.owner?
  end

  def counter?
    signed_in? && user.counter?
  end
end
