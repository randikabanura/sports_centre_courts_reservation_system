class Reservation < ApplicationRecord
  belongs_to :customer
  belongs_to :court

  validates_presence_of :start_time, :end_time
end
