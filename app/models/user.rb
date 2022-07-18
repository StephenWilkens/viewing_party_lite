class User < ApplicationRecord
  has_many :viewing_partys, dependent: :destroy
  has_many :attendees
  has_many :viewing_partys, through: :attendees
  
  validates_presence_of :user_name, :email, :password_digest
  validates_uniqueness_of :email
  has_secure_password
end
