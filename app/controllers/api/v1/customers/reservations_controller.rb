class Api::V1::Customers::ReservationsController < ApplicationController
  # before_action :authenticate_customer!

  def index
    court_id = params[:court_id]
    reservations_service = V1::Customers::ReservationsService.new(court_id: court_id)
    @reservations = reservations_service.get_reservations(date: params[:date])
    set_status(@reservations)
  end

  def create
    start_time = create_reservation_params[:start_time]
    reservations_service = V1::Customers::ReservationsService.new(court_id: create_reservation_params[:court_id])
    @status, @data = reservations_service.create_reservation(start_time)
  end

  def update
    id = params[:id]
    start_time = update_reservation_params[:start_time]
    notes = update_reservation_params[:notes]

    reservations_service = V1::Customers::ReservationsService.new(court_id: update_reservation_params[:court_id])
    @status, @data = reservations_service.update_reservation(id, start_time, notes)
  end

  def show
    reservations_service = V1::Customers::ReservationsService.new
    @status, @data = reservations_service.get_a_reservation(params[:id])
  end

  def destroy
    id = params[:id]
  end

  private

  def set_status(object)
    @status = object.present? ? true : false
  end

  def create_reservation_params
    params.require(:reservation).permit(:start_time, :court_id)
  end

  def update_reservation_params
    params.require(:reservation).permit(:start_time, :court_id, :notes)
  end
end
