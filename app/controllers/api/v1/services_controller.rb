module Api
  module V1
    class ServicesController < Api::BaseController
      skip_before_action :authenticate_with_token!, only: [:index, :show]
      before_action :set_service, only: [:show]

      def index
        services = Job.includes(:repair_jobs).by_name
        render json: services.map { |service| service_document(service) }
      end

      def show
        render json: service_document(@service)
      end

      def create
        service = Job.new(service_params)
        if service.save
          render json: service_document(service), status: :created, location: api_v1_service_url(service)
        else
          render json: { errors: service.errors.full_messages }, status: :unprocessable_content
        end
      end

      private

      def set_service
        @service = Job.includes(:repair_jobs).find(params[:id])
      end

      def service_params
        # si no viene ni name ni price es un body mal armado (400), no un service invalido (422)
        permitted = params.expect(service: [:name, :price])
        raise ActionController::ParameterMissing, :service if permitted.empty?
        permitted
      end

      def service_document(service)
        {
          id: service.id,
          name: service.name,
          price: format("%.2f", service.price),
          repairs_count: service.repair_jobs.map(&:repair_id).uniq.size
        }
      end
    end
  end
end
