module Api
  class BaseController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    # todo pide token salvo lo que se salta a proposito (el price list).
    # una ruta que no existe responde 404 igual, con o sin token
    before_action :authenticate_with_token!, except: :route_not_found

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::ParameterMissing, with: :render_bad_request
    rescue_from ActionDispatch::Http::Parameters::ParseError, with: :render_bad_request

    def route_not_found
      render json: { errors: ["no route matches #{request.method} #{request.path}"] }, status: :not_found
    end

    private

    def authenticate_with_token!
      expected = Rails.application.credentials.api_token.to_s

      authenticated = authenticate_with_http_token do |token, _options|
        expected.present? && ActiveSupport::SecurityUtils.secure_compare(token, expected)
      end

      render json: { errors: ["a valid token is required"] }, status: :unauthorized unless authenticated
    end

    def render_not_found
      render json: { errors: ["record not found"] }, status: :not_found
    end

    def render_bad_request(exception = nil)
      render json: { errors: [exception&.message || "the request body is missing required data"] }, status: :bad_request
    end
  end
end
