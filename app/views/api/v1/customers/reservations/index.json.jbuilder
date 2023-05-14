json.status @status

json.data do
  if @status
    json.array! @reservations do |reservation|
      json.id reservation.id
      json.start_time reservation.start_time
      json.end_time reservation.end_time
      json.canceled reservation.canceled
      json.notes reservation.notes
      json.created_at reservation.created_at
      json.updated_at reservation.updated_at
    end
  else
    json.message @data
  end
end
