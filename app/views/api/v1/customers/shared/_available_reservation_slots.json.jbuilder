json.available_reservations do
  json.array! available_reservation_slots do |available_slot|
    json.court_name available_slot[:court_name]
    json.court_id available_slot[:court_id]
    json.court_type available_slot[:court_type]
    json.start_time available_slot[:start_time]
    json.end_time available_slot[:end_time]
  end
end
