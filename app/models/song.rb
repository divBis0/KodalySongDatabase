class Song < ApplicationRecord
  belongs_to :user
  has_many :fields
  has_many :field_categories, :through => :fields
  
  # ensure that a user_id is present
  validates :user_id, presence: true
  
  # ensure that title is present
  validates :title, presence: true
  
  paginates_per 25
end
