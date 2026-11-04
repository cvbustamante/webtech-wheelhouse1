class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # si una accion se olvida de preguntarle a la policy, o un index no usa el scope, revienta.
  # las acciones publicas que se saltan esto estan en docs/decisions.md
  # (con if/unless y no only/except, porque no todos los controllers tienen index)
  after_action :verify_authorized, unless: -> { action_name == "index" }
  after_action :verify_policy_scoped, if: -> { action_name == "index" }

  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  private

  # la policy recibe la cuenta de la sesion. en las acciones publicas (services)
  # la sesion no se carga sola, por eso se retoma aca
  def pundit_user
    resume_session
    Current.user
  end

  def render_forbidden
    render "errors/forbidden", status: :forbidden
  end
end
