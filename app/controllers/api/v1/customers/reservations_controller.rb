class Api::V1::Customers::ReservationsController < ApplicationController
  # The line below is commented out to disable authentication for demo purposes.
  # In a production environment, this line should be uncommented to enforce authentication.
  # before_action :authenticate_customer!

  # Retrieves a list of reservations based on the provided parameters.
  def index
    reservations_service = V1::Customers::ReservationsService.new(court_id: index_reservation_params[:court_id])
    @reservations = reservations_service.get_reservations(date: index_reservation_params[:date],
                                                          canceled: index_reservation_params[:canceled])
    set_status(true)
  end

  # Creates a new reservation with the provided start time.
  def create
    start_time = create_reservation_params[:start_time]
    reservations_service = V1::Customers::ReservationsService.new(court_id: create_reservation_params[:court_id])
    @status, @data = reservations_service.create_reservation(start_time)
    set_status(@status)
  end

  # Updates an existing reservation with the provided ID, start time, and notes.
  def update
    id = params[:id]
    start_time = update_reservation_params[:start_time]
    notes = update_reservation_params[:notes]

    reservations_service = V1::Customers::ReservationsService.new(court_id: update_reservation_params[:court_id])
    @status, @data = reservations_service.update_reservation(id, start_time, notes)
    set_status(@status)
  end

  # Retrieves the details of a specific reservation based on the provided ID.
  def show
    reservations_service = V1::Customers::ReservationsService.new
    @status, @data = reservations_service.get_reservation(params[:id])
    set_status(@status)
  end

  # Cancels an existing reservation based on the provided ID.
  def destroy
    id = params[:id]

    reservations_service = V1::Customers::ReservationsService.new
    @status, @data = reservations_service.cancel_reservation(id)
    set_status(@status)
  end

  # Retrieves the availability of reservations based on the provided parameters.
  def availability
    options = {
      date: availability_reservation_params[:date],
      start_time: availability_reservation_params[:start_time],
      end_time: availability_reservation_params[:end_time],
      court_type: availability_reservation_params[:court_type]
    }

    reservations_service = V1::Customers::ReservationsService.new(court_id: availability_reservation_params[:court_id])
    @status, @data = reservations_service.availability_reservations(**options)
    set_status(@status)
  end

  private

  # Sets the response status based on the provided status value.
  def set_status(status)
    render status: status ?  :ok : :bad_request
  end

  # Strong parameters for creating a reservation.
  def create_reservation_params
    params.require(:reservation).permit(:start_time, :court_id)
  end

  # Strong parameters for updating a reservation.
  def update_reservation_params
    params.require(:reservation).permit(:start_time, :court_id, :notes)
  end

  # Strong parameters for retrieving reservations.
  def index_reservation_params
    params.permit(:court_id, :date, :canceled)
  end

  # Strong parameters for retrieving availability of reservations.
  def availability_reservation_params
    params.permit(:date, :start_time, :end_time, :court_id, :court_type)
  end
end
