class Court < ApplicationRecord
  enum :court_type, { tennis: 0, basketball: 1, football: 2, volleyball: 3 }

  validates_presence_of :name, :court_type, :active
end
