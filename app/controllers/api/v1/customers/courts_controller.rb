class Api::V1::Customers::CourtsController < ApplicationController
  # before_action :authenticate_customer!
  before_action :set_courts_service

  def show
    @date = params[:date] || DateTime.now
    @status, @data = @courts_service.get_court(params[:id])
    set_status(@status)
  end

  def index
    @date = params[:date] || DateTime.now
    @courts = @courts_service.get_courts
    set_status(true)
  end

  private

  def set_courts_service
    @courts_service = V1::Customers::CourtsService.new
  end

  def set_status(status)
    render status: status ?  :ok : :bad_request
  end
end
