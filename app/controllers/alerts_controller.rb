class AlertsController < ApplicationController
  include AlertHelper
  before_action :find_alert, only: [:destroy]

  def index
    @alerts = @current_user.alerts
    @alerts = @alerts.filter_by_statuses(params[:status].split(",")) if params[:status]
    @alerts = @alerts.limit(params[:size]) if params[:size]

    render json: {
      status: 200,
      alerts: @alerts.order('id desc').as_json(
        only: [
          :id,
          :coin_id,
          :status,
          :price,
          :created_at
        ]
      )
    }
  end

  def create
    @alert = @current_user.alerts.new(alert_params)
    if @alert.save
      store_alert_in_redis(@alert.coin_id, @alert.price, @alert.id)
      render json: {
        status: 201,
        alert: @alert.as_json(only: [:id, :coin_id, :price, :status])
      }
    else
      render json: {
        status: :unprocessable_entity,
        errors: @alert.errors.full_messages
      }
    end
  end

  def destroy
    @alert.status = Alert.statuses['DELETED']
    if @alert.save
      remove_alert_from_redis(@alert.coin_id, @alert.id)
      head :ok
    else
      head :internal_server_error
    end
  end

  private

  def find_alert
    @alert = @current_user.alerts.non_deleted.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  def alert_params
    params.permit(
      :coin_id,
      :price
    )
  end
end
