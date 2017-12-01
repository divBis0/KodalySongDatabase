class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         #:recoverable, :rememberable, :trackable, :validatable
         :rememberable, :validatable, :invite_for => 2.weeks
  has_many :songs
  has_many :sources
end
