json.status @status

json.data do
  json.start_time @reservation.start_time
  json.end_time @reservation.end_time
  json.canceled @reservation.canceled
  json.notes @reservation.notes
  json.created_at @reservation.created_at
  json.updated_at @reservation.updated_at
end
