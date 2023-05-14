class Api::V1::Customers::ReservationsController < ApplicationController
  # before_action :authenticate_customer!

  def index
    court_id = params[:court_id]
    reservations_service = V1::Customers::ReservationsService.new(court_id: court_id)
    @reservations = reservations_service.get_reservations
    set_status(@reservations)
  end

  def create
    start_time = create_reservation_params[:start_time]
    reservations_service = V1::Customers::ReservationsService.new(court_id: create_reservation_params[:court_id])
    @status, @data = reservations_service.create_a_reservation(start_time)
  end

  def update
  end

  def show
    reservations_service = V1::Customers::ReservationsService.new
    @reservation = reservations_service.get_a_reservation(params[:id])
    set_status(@reservation)
  end

  def destroy
  end

  private

  def set_status(object)
    @status = object.present? ? true : false
  end

  def create_reservation_params
    params.require(:reservation).permit(:start_time, :court_id)
  end
end
