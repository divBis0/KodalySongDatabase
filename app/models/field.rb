class Field < ApplicationRecord
  enum type: [:str, :num, :rhythm, :str_set, :rhythm_set]
  belongs_to :field_category
  belongs_to :song
end
