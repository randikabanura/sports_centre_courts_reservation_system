class Api::V1::Customers::CourtsController < ApplicationController
  # The line below is commented out to disable authentication for demo purposes.
  # In a production environment, this line should be uncommented to enforce authentication.
  # before_action :authenticate_customer!
  before_action :set_courts_service

  # Retrieves the details of a specific court.
  def show
    @date = params[:date] || DateTime.now
    @status, @data = @courts_service.get_court(params[:id])
    set_status(@status)
  end

  # Retrieves a list of courts.
  def index
    @date = params[:date] || DateTime.now
    @courts = @courts_service.get_courts
    set_status(true)
  end

  private

  # Sets the CourtsService instance.
  def set_courts_service
    @courts_service = V1::Customers::CourtsService.new
  end

  # Sets the response status based on the provided status value.
  def set_status(status)
    render status: status ?  :ok : :bad_request
  end
end
