class User < ApplicationRecord
  has_secure_password validations: false
  has_many :sessions, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_many :integrations, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  LOGIN_TOKEN_EXPIRATION = 15.minutes

  def generate_login_token!
    update!(
      login_token: SecureRandom.urlsafe_base64(32),
      login_token_sent_at: Time.current
    )
  end

  def clear_login_token!
    update!(login_token: nil, login_token_sent_at: nil)
  end

  def self.find_by_login_token(token)
    return nil if token.blank?

    user = find_by(login_token: token)
    return nil unless user
    return nil if user.login_token_sent_at.nil?
    return nil if user.login_token_sent_at < LOGIN_TOKEN_EXPIRATION.ago

    user
  end

  def send_magic_link!
    generate_login_token!
    SessionMailer.magic_link(self).deliver_later
  end
end
