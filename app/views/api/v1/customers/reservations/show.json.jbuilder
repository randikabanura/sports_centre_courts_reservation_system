json.status @status

json.data do
  if @status
    @reservation = @data
    json.id @reservation.id
    json.start_time @reservation.start_time
    json.end_time @reservation.end_time
    json.court_id @reservation.court_id
    json.canceled @reservation.canceled
    json.notes @reservation.notes
    json.created_at @reservation.created_at
    json.updated_at @reservation.updated_at
  else
    json.message @data
  end
end
