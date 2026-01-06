class WebhookEvent < ApplicationRecord
  belongs_to :board

  validates :action, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_action, ->(action) { where(action: action) }
end
