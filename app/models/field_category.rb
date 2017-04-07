class FieldCategory < ApplicationRecord
  has_many :fields
  has_many :songs, :through => :fields
end
