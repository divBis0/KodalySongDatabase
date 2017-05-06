class FieldEntry < ApplicationRecord
  belongs_to :song
  belongs_to :field
  delegate :field_category, :to => :field, :allow_nil => true
end
