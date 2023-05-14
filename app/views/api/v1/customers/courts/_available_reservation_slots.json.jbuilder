json.available_reservations do
  json.array! available_reservation_slots do |available_slot|
    json.start_time available_slot[:start_time]
    json.end_time available_slot[:end_time]
  end
end
