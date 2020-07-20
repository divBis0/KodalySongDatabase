class Song < ApplicationRecord
  belongs_to :user
  has_many :field_entries, dependent: :destroy
  has_many :fields,           :through => :field_entries,  :source => :field
  #has_many :field_categories, :through => :fields,        :source => :field_categories
  belongs_to :source, optional: true
  has_many :concepts, dependent: :destroy
  
  accepts_nested_attributes_for :field_entries,
    :allow_destroy => true,
    :reject_if => proc {|attributes| attributes[:data].blank?}
    
  accepts_nested_attributes_for :source, reject_if: lambda {|attributes| attributes['title'].blank?}
  
  accepts_nested_attributes_for :concepts,
    :allow_destroy => true,
    :reject_if => proc {|attributes| attributes[:name].blank?}
  
  # ensure that a user_id is present
  validates :user_id, presence: true
  
  # ensure that title is present
  validates :title, presence: true
  
  paginates_per 25
  
  def next
    user.songs.where("title > ?",title).order(:title).first
  end
end
