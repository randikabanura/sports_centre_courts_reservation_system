
class V1::Customers::ReservationsService

  attr_accessor :court, :customer

  def initialize(court_id: nil, customer_id: nil)
    @court = Court.find(court_id) if court_id.present?
    @customer = Customer.find(customer_id) if customer_id.present?
    @customer = Customer.first if @customer.blank?
  end

  def create_reservation(start_time)
    start_time = DateTime.parse(start_time).change(offset: '0').beginning_of_hour
    end_time = start_time + 1.hour
    reservation = Reservation.new(customer: customer, court: court, start_time: start_time, end_time: end_time)
    reservation.save ? [true, reservation] : [false, "Reservation creation failed"]
  rescue StandardError => e
    [false, "Reservation creation failed"]
  end

  def update_reservation(id, start_time, notes = '')
    _, reservation = get_a_reservation(id)
    return [false, "Reservation update failed"] if reservation.blank?

    start_time = DateTime.parse(start_time).change(offset: '0').beginning_of_hour
    end_time = start_time + 1.hour
    reservation.assign_attributes(court: court, start_time: start_time, end_time: end_time, notes: notes)
    reservation.save ? [true, reservation] : [false, "Reservation update failed"]
  rescue StandardError => e
    [false, "Reservation update failed"]
  end

  def get_a_reservation(id)
    reservation = Reservation.find(id)
    reservation.present? ? [true, reservation] : [false, "Reservation not found"]
  rescue StandardError => e
    [false, "Reservation not found"]
  end

  def get_reservations(**options)
    conditions = {}
    date = options[:date]

    conditions[:start_time] = DateTime.parse(date.to_s).change(offset: '0' ).all_day if date.present?
    conditions[:court] = court if court.present?
    conditions[:customer] =  customer if customer.present?

    Reservation.where(**conditions)
  end

  def already_reserved?(current_reservation_id, start_time)
    start_time = start_time.beginning_of_hour
    reservations = get_reservations(date: start_time)
    reservations.where(start_time: start_time).where.not(id: current_reservation_id).count.positive?
  end
end
