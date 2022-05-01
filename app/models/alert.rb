class Alert < ApplicationRecord
  enum :status, %i(CREATED TRIGGERED FAILED)
  validates :coin_id, :user_id, :price, presence: true
  belongs_to :user
end
