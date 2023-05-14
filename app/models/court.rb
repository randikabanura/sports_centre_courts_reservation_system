class Court < ApplicationRecord
  enum :court_type, { tennis: 0, basketball: 1, football: 2, volleyball: 3 }

  scope :active, -> { where(active: true)}
  scope :not_active, -> { where(active: false)}
  scope :with_court_type, -> (court_type) { where(court_type: court_type)}

  validates_presence_of :name, :court_type, :active
  validates_inclusion_of :court_type, in: court_types.keys

  # Retrieves available reservation slots for the court on the specified date.
  # Params:
  # - date: The date for which to retrieve available reservation slots
  # - options: Additional options for filtering available reservation slots
  # Returns:
  # - An array of available reservation slots, each represented as a hash with the following keys:
  #   - court_name: The name of the court
  #   - court_id: The ID of the court
  #   - court_type: The type of the court
  #   - start_time: The start time of the reservation slot
  #   - end_time: The end time of the reservation slot
  def available_reservation_slots(date, **options)
    date = date.beginning_of_day
    reservation_service = V1::Customers::ReservationsService.new(court_id: id)
    reservations = reservation_service.get_reservations(date: date, canceled: false).pluck(:start_time).map(&:hour)

    start_hour = DateTime.parse(options[:start_time]).hour rescue 0
    end_hour = DateTime.parse(options[:end_time]).hour rescue 23
    selected_hours = (start_hour..end_hour)

    available_reservations = []
    (0..23).each do |index|
      next if reservations.include?(index)
      next unless selected_hours.include?(index)

      available_reservations << {
        court_name: name,
        court_id: id,
        court_type: court_type,
        start_time: date + index.hours,
        end_time: date + (index + 1).hours,
      }
    end

    available_reservations
  end
end
