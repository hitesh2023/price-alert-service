class User < ApplicationRecord
  has_secure_password
  has_many :alerts
  validates_uniqueness_of :email
end
