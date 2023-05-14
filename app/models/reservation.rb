class Reservation < ApplicationRecord
  belongs_to :customer
  belongs_to :court

  validates_presence_of :start_time, :end_time
  validate :already_reserved?, :not_in_past?

  def already_reserved?
    reservation_service = V1::Customers::ReservationsService.new(court_id: court.id)
    if reservation_service.already_reserved?(id, start_time)
      errors.add(:start_time)
    end
  end

  def not_in_past?
    if start_time.past?
      errors.add(:start_time)
    end
  end
end
