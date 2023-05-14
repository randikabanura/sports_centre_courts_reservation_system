
class V1::Customers::CourtsService

  def initialize
    super
  end

  def get_court(id)
    court = Court.find(id)
    court.present? ? [true, court] : [false, "Court not found"]
  rescue StandardError => e
    [false, "Court not found"]
  end

  def get_courts(**options)
    Court.active
  end
end
