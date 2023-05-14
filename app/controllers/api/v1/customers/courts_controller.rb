class Api::V1::Customers::CourtsController < ApplicationController
  # before_action :authenticate_customer!
  before_action :set_courts_service

  def show
    @date = params[:date] || DateTime.now
    @court = @courts_service.get_a_court(params[:id])
    set_status(@court)
  end

  def index
    @date = params[:date] || DateTime.now
    @courts = @courts_service.get_courts
    set_status(@courts)
  end

  private

  def set_courts_service
    @courts_service = V1::Customers::CourtsService.new
  end

  def set_status(object)
    @status = object.present? ? true : false
  end
end
