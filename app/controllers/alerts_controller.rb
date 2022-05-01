class AlertsController < ApplicationController
  before_action :find_alert, only: [:destroy]

  def index
    render json: {
      status: 200,
      alerts: @current_user.alerts.as_json(
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
    @alert.destroy!
    head :no_content
  end

  private

  def find_alert
    @alert = @current_user.alerts.find(params[:id])
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
