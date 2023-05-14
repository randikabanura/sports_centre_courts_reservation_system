
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
    _, reservation = get_reservation(id)
    return [false, "Reservation update failed"] if reservation.blank?

    start_time = DateTime.parse(start_time).change(offset: '0').beginning_of_hour
    end_time = start_time + 1.hour
    reservation.assign_attributes(court: court, start_time: start_time, end_time: end_time, notes: notes)
    reservation.save ? [true, reservation] : [false, "Reservation update failed"]
  rescue StandardError => e
    [false, "Reservation update failed"]
  end

  def get_reservation(id)
    reservation = Reservation.find(id)
    reservation.present? ? [true, reservation] : [false, "Reservation not found"]
  rescue StandardError => e
    [false, "Reservation not found"]
  end

  def cancel_reservation(id)
    _, reservation = get_reservation(id)
    return [false, "Reservation cancel failed"] if reservation.blank?

    reservation.assign_attributes(canceled: true)
    reservation.save ? [true, reservation] : [false, "Reservation cancel found"]
  rescue StandardError => e
    [false, "Reservation cancel found"]
  end

  def availability_reservations(**options)
    reservations_by_date = {}
    array_of_dates = []
    array_of_dates << DateTime.parse(options[:date].to_s).change(offset: '0' ).to_date if options[:date].present?
    array_of_dates << (Date.today..(Date.today + 7.days)) if array_of_dates.empty?

    Court.active.each do |selected_court|
      next if court.present? && court != selected_court
      next if options[:court_type].present? && options[:court_type] != selected_court.court_type

      array_of_dates.each do |date|
        reservations_by_date[date.to_s.to_sym] = selected_court.available_reservation_slots(date, **options)
      end
    end

    [true, reservations_by_date]
  rescue StandardError => e
    [false, "Reservations not found"]
  end

  def get_reservations(**options)
    conditions = {}
    date = options[:date]

    conditions[:start_time] = DateTime.parse(date.to_s).change(offset: '0' ).all_day if date.present?
    conditions[:court] = court if court.present?
    conditions[:customer] = customer if customer.present?
    conditions[:canceled] = options[:canceled] if options[:canceled].present?
    conditions[:court][:court_type] = options[:court_type] if options[:court_type].present?

    Reservation.includes(:court).where(**conditions)
  end

  def already_reserved?(current_reservation_id, start_time)
    start_time = start_time.beginning_of_hour
    reservations = get_reservations(date: start_time, canceled: false)
    reservations.where(start_time: start_time).where.not(id: current_reservation_id).count.positive?
  end
end
