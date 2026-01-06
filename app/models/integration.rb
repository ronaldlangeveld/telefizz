class Integration < ApplicationRecord
  belongs_to :user
  has_many :board_integrations, dependent: :destroy
  has_many :boards, through: :board_integrations

  validates :name, presence: true

  # STI subclasses should define their own validations and accessors
  # Each subclass must implement:
  #   - send_message(text) -> boolean
  #   - format_message(text) -> string (optional, defaults to pass-through)

  def send_message(_text)
    raise NotImplementedError, "#{self.class} must implement #send_message"
  end

  # Override in subclasses if platform needs different formatting
  def format_message(text)
    text
  end
end
