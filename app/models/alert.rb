class Alert < ApplicationRecord
  enum :status, %i(CREATED TRIGGERED DELETED FAILED)
  validates :coin_id, :user_id, :price, presence: true
  belongs_to :user

  scope :deleted, -> { where(status: Alert.statuses['DELETED']) }
  scope :failed, -> { where(status: Alert.statuses['FAILED']) }
  scope :non_deleted, -> { where.not(status: Alert.statuses['DELETED']) }

  class << self
    def filter_by_statuses(statuses)
      where(status: statuses)
    end
  end
end
