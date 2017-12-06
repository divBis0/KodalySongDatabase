class Concept < ApplicationRecord
  belongs_to :song
  
  # ensure that a name is present
  validates :name, presence: true
end
