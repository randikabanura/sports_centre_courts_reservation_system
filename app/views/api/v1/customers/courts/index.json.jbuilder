json.status @status

json.data do
  json.array! @courts do |court|
    available_reservation_slots = court.available_reservation_slots(@date) || []

    json.name court.name
    json.court_type court.court_type
    json.active court.active
    json.partial! 'api/v1/customers/shared/available_reservation_slots', locals: { available_reservation_slots: available_reservation_slots }
    json.created_at court.created_at
    json.updated_at court.updated_at
  end
end
