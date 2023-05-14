
class V1::Customers::CourtsService

  def initialize
    super
  end

  def get_a_court(id)
    Court.find(id)
  end

  def get_courts(**options)
    Court.active
  end
end
