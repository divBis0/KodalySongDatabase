class Source < ApplicationRecord
  belongs_to :user
  has_many :song
  
  # ensure that a user_id is present
  validates :user_id, presence: true
  
  # ensure that title is present
  validates :title, presence: true
  
  paginates_per 25
  
  default_scope ->{ order('title') }
  
  def title_with_author
    if author.nil? || author.empty?
      title
    else
      last_name = author.match /(\S+)\s*$/
      "#{title} (#{last_name})"
    end
  end
end
