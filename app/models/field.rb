class Field < ApplicationRecord
  enum display_type: [:string, :integer, :boolean, :rhythm, :url, :string_set, :rhythm_set]
  belongs_to :field_category
end
