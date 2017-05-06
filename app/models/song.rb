class Song < ApplicationRecord
  belongs_to :user
  has_many :field_entries
  has_many :fields,           :through => :field_entries,  :source => :field
  #has_many :field_categories, :through => :fields,        :source => :field_categories
  
  accepts_nested_attributes_for :field_entries,
    :allow_destroy => true,
    :reject_if => proc {|attributes| attributes[:data].blank?}
  
  # ensure that a user_id is present
  validates :user_id, presence: true
  
  # ensure that title is present
  validates :title, presence: true
  
  paginates_per 25
end
