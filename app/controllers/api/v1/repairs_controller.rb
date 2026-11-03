module Api
  module V1
    class RepairsController < Api::BaseController
      def index
        repairs = Repair.includes(:customer, bike: :bike_model, repair_jobs: :job).by_promised_on

        if params[:state].present?
          unless Repair.statuses.key?(params[:state])
            render json: { errors: ["state must be one of: #{Repair.statuses.keys.join(', ')}"] }, status: :bad_request
            return
          end
          repairs = repairs.where(status: params[:state])
        end

        render json: repairs.map { |repair| repair_document(repair) }
      end

      def show
        repair = Repair.includes(:customer, bike: :bike_model, repair_jobs: :job).find(params[:id])
        render json: repair_document(repair)
      end

      private

      def repair_document(repair)
        brand, model = split_bike_model(repair.bike.bike_model.name)
        total = repair.repair_jobs.sum(&:price_charged)

        {
          id: repair.id,
          state: repair.status,
          dropped_off_on: repair.created_at.to_date,
          promised_on: repair.promised_on,
          picked_up_on: repair.picked_up_at&.to_date,
          bike: {
            brand: brand,
            model: model,
            serial_number: repair.bike.serial_number
          },
          customer: { name: repair.customer.name },
          lines: repair.repair_jobs.map { |line| line_document(line) },
          total: format("%.2f", total),
          overdue: repair.overdue?,
          customer_answer: repair.customer_answer
        }
      end

      def line_document(repair_job)
        {
          service: repair_job.job.name,
          price_charged: format("%.2f", repair_job.price_charged)
        }
      end

      # el bike_model actual guarda "Trek Marlin" como un solo string;
      # la primera palabra es la marca y el resto el modelo
      def split_bike_model(name)
        brand, *rest = name.to_s.split(" ")
        model = rest.join(" ")
        model = brand if model.blank?
        [brand, model]
      end
    end
  end
end
