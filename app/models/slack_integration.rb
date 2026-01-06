class SlackIntegration < Integration
  REQUIRED_CONFIG = %w[webhook_url].freeze

  validate :config_has_required_keys

  def send_message(text)
    response = HTTParty.post(
      config["webhook_url"],
      body: {
        text: text,
        mrkdwn: true
      }.to_json,
      headers: { "Content-Type" => "application/json" },
      timeout: 10
    )

    if response.success?
      true
    else
      Rails.logger.error("Slack send failed: #{response.code} - #{response.body}")
      false
    end
  end

  private

  def config_has_required_keys
    REQUIRED_CONFIG.each do |key|
      errors.add(:config, "missing #{key}") if config[key].blank?
    end
  end
end
