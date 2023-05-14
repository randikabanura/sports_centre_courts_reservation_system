
class V1::Customers::CourtsService

  # Initializes a new instance of the CourtsService class.
  def initialize
    super
  end

  # Retrieves a court with the specified ID.
  # Params:
  # - id: The ID of the court to retrieve
  # Returns:
  # - An array with a boolean indicating if the court was found and the court object (if found),
  #   or an error message if the court was not found.
  def get_court(id)
    court = Court.find(id)
    court.present? ? [true, court] : [false, "Court not found"]
  rescue StandardError => e
    [false, "Court not found"]
  end

  # Retrieves courts based on the specified options.
  # Params:
  # - options: A hash containing the search criteria for courts
  # Returns:
  # - An array of active court objects matching the search criteria.
  def get_courts(**options)
    Court.active
  end
end
