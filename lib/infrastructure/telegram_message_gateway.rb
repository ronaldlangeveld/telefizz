require 'telegram/bot'

module Infrastructure
  class TelegramMessageGateway
    def initialize(bot_token:)
      @bot_token = bot_token
    end

    def send_message(message)
      Telegram::Bot::Client.run(@bot_token) do |bot|
        bot.api.send_message(
          chat_id: message.chat_id,
          text: message.text,
          parse_mode: message.parse_mode
        )
      end
    end
  end
end