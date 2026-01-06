class Board < ApplicationRecord
  belongs_to :user
  has_many :webhook_events, dependent: :destroy

  before_create :set_defaults
  before_create :set_uuid

  validates :name, presence: true

  def webhook_url
    base_url = ENV.fetch("APP_BASE_URL", "http://localhost:3000")
    "#{base_url}/webhooks/#{uuid}"
  end

  private

  def set_defaults
    self.name ||= "My Board"
  end

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
