
class V1::Customers::ReservationsService

  attr_accessor :court, :customer

  def initialize(court_id: nil, customer_id: nil)
    @court = Court.find(court_id) if court_id.present?
    @customer = Customer.find(customer_id) if customer_id.present?
    @customer = Customer.first if @customer.blank?
  end

  def create_a_reservation(start_time)
    start_time = DateTime.parse(start_time).beginning_of_hour
    end_time = start_time + 1.hour
    reservation = Reservation.new(customer: customer, court: court, start_time: start_time, end_time: end_time)
    reservation.save ? [true, reservation] : [false, "Reservation creation failed"]
  rescue StandardError => e
    [false, "Reservation creation failed"]
  end

  def get_a_reservation(id)
    Reservation.find(id)
  end

  def get_reservations(**options)
    conditions = {}
    date = options[:date]

    conditions[:start_time] = date.all_day if date.present?
    conditions[:court] = court if court.present?
    conditions[:customer] =  customer if customer.present?

    Reservation.where(**conditions)
  end

  def already_reserved?(start_time)
    start_time = start_time.beginning_of_hour
    reservations = get_reservations(date: start_time)
    reservations.where(start_time: start_time).count.positive?
  end
end
