class Court < ApplicationRecord
  enum :court_type, { tennis: 0, basketball: 1, football: 2, volleyball: 3 }

  validates_presence_of :name, :court_type, :active
  validates_inclusion_of :court_type, in: court_types.keys

  def available_reservation_slots(date)
    date = date.beginning_of_day
    reservation_service = V1::Customers::ReservationsService.new(court_id: id)
    reservations = reservation_service.get_reservations(date: date).pluck(:start_time).map(&:hour)

    available_reservations = []
    (0..23).each do |index|
      next if reservations.include?(index)

      available_reservations << {
        start_time: date + index.hours,
        end_time: date + (index + 1).hours,
      }
    end

    available_reservations
  end
end
