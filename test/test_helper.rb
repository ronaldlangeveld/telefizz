ENV['RACK_ENV'] = 'test'
ENV['TELEGRAM_BOT_TOKEN'] = 'test_bot_token'
ENV['TELEGRAM_CHAT_ID'] = '123456789'
ENV['FIZZY_WEBHOOK_SECRET'] = 'test_secret'

require 'minitest/autorun'
require 'rack/test'
require 'webmock/minitest'
require 'json'

# Load application
require_relative '../lib/entities/event'
require_relative '../lib/entities/message'
require_relative '../lib/use_cases/process_webhook_event'
require_relative '../lib/interfaces/webhook_controller'
require_relative '../lib/infrastructure/telegram_message_gateway'

WebMock.disable_net_connect!
