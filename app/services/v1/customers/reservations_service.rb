class V1::Customers::ReservationsService

  attr_accessor :court, :customer

  # Initializes a new instance of the ReservationsService class.
  # Params:
  # - court_id: Optional. The ID of the court associated with the service (default: nil)
  # - customer_id: Optional. The ID of the customer associated with the service (default: nil)
  def initialize(court_id: nil, customer_id: nil)
    @court = Court.find(court_id) if court_id.present?
    @customer = Customer.find(customer_id) if customer_id.present?
    @customer = Customer.first if @customer.blank?
  end

  # Creates a new reservation for a customer.
  # Params:
  # - start_time: Start time of the reservation
  # Returns:
  # - The created reservation object
  def create_reservation(start_time)
    start_time = DateTime.parse(start_time).change(offset: '0').beginning_of_hour
    end_time = start_time + 1.hour
    reservation = Reservation.new(customer: customer, court: court, start_time: start_time, end_time: end_time)
    reservation.save ? [true, reservation] : [false, "Reservation creation failed"]
  rescue StandardError => e
    [false, "Reservation creation failed"]
  end

  # Updates an existing reservation with the specified ID.
  # Params:
  # - id: The ID of the reservation to update
  # - start_time: The new start time for the reservation
  # - notes: Optional. Additional notes or comments about the reservation (default: '')
  # Returns:
  # - The updated reservation object
  def update_reservation(id, start_time, notes = '')
    _, reservation = get_reservation(id)
    return [false, "Reservation update failed"] if reservation.blank?

    start_time = DateTime.parse(start_time).change(offset: '0').beginning_of_hour
    end_time = start_time + 1.hour
    reservation.assign_attributes(court: court, start_time: start_time, end_time: end_time, notes: notes)
    reservation.save ? [true, reservation] : [false, "Reservation update failed"]
  rescue StandardError => e
    [false, "Reservation update failed"]
  end

  # Retrieves the reservation with the specified ID.
  # Params:
  # - id: The ID of the reservation to retrieve
  # Returns:
  # - The reservation object
  def get_reservation(id)
    reservation = Reservation.find(id)
    reservation.present? ? [true, reservation] : [false, "Reservation not found"]
  rescue StandardError => e
    [false, "Reservation not found"]
  end

  # Cancels the reservation with the specified ID.
  # Params:
  # - id: The ID of the reservation to cancel
  # Returns:
  # - The reservation object
  def cancel_reservation(id)
    _, reservation = get_reservation(id)
    return [false, "Reservation cancel failed"] if reservation.blank?

    reservation.assign_attributes(canceled: true)
    reservation.save ? [true, reservation] : [false, "Reservation cancel found"]
  rescue StandardError => e
    [false, "Reservation cancel found"]
  end

  # Retrieves the availability of reservations based on the specified options.
  # Params:
  # - options: A hash containing the search criteria for availability
  #   - date: Optional. The date for the reservation availability search
  #   - start_time: Optional. The start time for the reservation availability search
  #   - start_time: Optional. The end time for the reservation availability search
  # Returns:
  # - An array of available reservation objects by group into dates
  def availability_reservations(**options)
    reservations_by_date = {}
    array_of_dates = []
    array_of_dates << DateTime.parse(options[:date].to_s).change(offset: '0').to_date if options[:date].present?
    array_of_dates << (Date.today..(Date.today + 7.days)).to_a if array_of_dates.empty?
    array_of_dates.flatten!

    Court.active.each do |selected_court|
      next if court.present? && court != selected_court
      next if options[:court_type].present? && options[:court_type] != selected_court.court_type

      array_of_dates.each do |date|
        reservations_by_date[date.to_s.to_sym] = [] if reservations_by_date[date.to_s.to_sym].blank?
        reservations_by_date[date.to_s.to_sym] = reservations_by_date[date.to_s.to_sym] + selected_court.available_reservation_slots(date, **options)
        reservations_by_date[date.to_s.to_sym] = reservations_by_date[date.to_s.to_sym].flatten
      end
    end

    [true, reservations_by_date]
  rescue StandardError => e
    [false, "Reservations not found"]
  end

  # Retrieves reservations based on the specified options.
  # Params:
  # - options: A hash containing the search criteria for reservations
  #   - date: Optional. The date for the reservation availability search
  #   - start_time: Optional. The start time for the reservation availability search
  #   - start_time: Optional. The end time for the reservation availability search
  # Returns:
  # - An ActiveRecord array of reservation objects
  def get_reservations(**options)
    conditions = {}
    date = options[:date]

    conditions[:start_time] = DateTime.parse(date.to_s).change(offset: '0').all_day if date.present?
    conditions[:court] = court if court.present?
    conditions[:customer] = customer if customer.present?
    conditions[:canceled] = options[:canceled] if [true, false].include? options[:canceled]
    conditions[:court][:court_type] = options[:court_type] if options[:court_type].present?

    Reservation.includes(:court).where(**conditions)
  end

  # Checks if a reservation with the specified start time overlaps with an existing reservation.
  # Params:
  # - current_reservation_id: The ID of the current reservation being checked
  # - start_time: The start time of the reservation to check for conflicts
  # Returns:
  # - Boolean indicating whether there is a conflict (true) or not (false)
  def already_reserved?(current_reservation_id, start_time)
    start_time = start_time.beginning_of_hour
    reservations = get_reservations(date: start_time, canceled: false)
    reservations.where(start_time: start_time).where.not(id: current_reservation_id).count.positive?
  end
end
