json.status @status

json.data do
  if @status
    @reservations_by_dates = @data
    @reservations_by_dates.each do |date, available_reservation_slots|
      json.set! date.to_s do
        json.partial! 'api/v1/customers/shared/available_reservation_slots_by_date', locals: { available_reservation_slots: available_reservation_slots }
      end
    end
  else
    json.message @data
  end
end
