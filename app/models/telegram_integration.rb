class TelegramIntegration < Integration
  REQUIRED_CONFIG = %w[bot_token chat_id].freeze

  validate :config_has_required_keys

  def send_message(text)
    url = "https://api.telegram.org/bot#{config["bot_token"]}/sendMessage"
    response = HTTParty.post(
      url,
      body: {
        chat_id: config["chat_id"],
        text: text,
        parse_mode: "HTML"  # Keeps your formatting (bold, links, etc.)
      }.to_json,
      headers: { "Content-Type" => "application/json" },
      timeout: 10  # Safety
    )

    if response.success?
      true
    else
      Rails.logger.error("Telegram send failed: #{response.code} - #{response.body}")
      false  # Or raise if you want hard fails
    end
  end

  private

  def config_has_required_keys
    REQUIRED_CONFIG.each do |key|
      errors.add(:config, "missing #{key}") if config[key].blank?
    end
  end
end
