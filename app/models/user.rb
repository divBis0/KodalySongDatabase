class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable and :omniauthable,  :trackable,
  devise  :invitable, :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :lockable,
          :invite_for => 4.weeks
  has_many :songs
  has_many :sources
end
