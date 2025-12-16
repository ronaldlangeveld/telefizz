require 'sinatra'
require 'json'
require_relative 'lib/entities/event'
require_relative 'lib/entities/message'
require_relative 'lib/use_cases/process_webhook_event'
require_relative 'lib/interfaces/webhook_controller'
require_relative 'lib/infrastructure/telegram_message_gateway'

# Dependency injection
message_gateway = Infrastructure::TelegramMessageGateway.new(bot_token: ENV['TELEGRAM_BOT_TOKEN'])
process_webhook_event_use_case = UseCases::ProcessWebhookEvent.new(message_gateway: message_gateway)
webhook_controller = Interfaces::WebhookController.new(process_webhook_event_use_case: process_webhook_event_use_case)

post '/webhook' do
  request.body.rewind
  body = request.body.read
  headers = {
    'X-Webhook-Signature' => request.env['HTTP_X_WEBHOOK_SIGNATURE'],
    'X-Webhook-Timestamp' => request.env['HTTP_X_WEBHOOK_TIMESTAMP']
  }
  response = webhook_controller.handle_webhook(body, headers)
  status response[:status]
  response[:body]
end