ENV['RACK_ENV'] = 'test'
ENV['TELEGRAM_BOT_TOKEN'] = 'test_bot_token'
ENV['TELEGRAM_CHAT_ID'] = '123456789'
ENV['FIZZY_WEBHOOK_SECRET'] = 'test_secret'

require 'minitest/autorun'
require 'rack/test'
require 'webmock/minitest'
require 'json'

require_relative '../../app'
require_relative '../fixtures/webhook_payloads'

WebMock.disable_net_connect!

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    # Stub Telegram API with proper response structure
    telegram_response = {
      "ok" => true,
      "result" => {
        "message_id" => 123,
        "from" => { "id" => 1234567890, "is_bot" => true, "first_name" => "TestBot", "username" => "test_bot" },
        "chat" => { "id" => 123456789, "first_name" => "Test", "type" => "private" },
        "date" => 1734307200,
        "text" => "Test message"
      }
    }.to_json
    stub_request(:post, /api.telegram.org/)
      .to_return(status: 200, body: telegram_response, headers: { 'Content-Type' => 'application/json' })
  end

  def test_webhook_endpoint_exists
    payload = Fixtures::WebhookPayloads.card_published
    body = payload.to_json
    signature = Fixtures::WebhookPayloads.generate_signature(body, ENV['FIZZY_WEBHOOK_SECRET'])

    post '/webhook', body, {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_X_WEBHOOK_SIGNATURE' => signature
    }

    assert_equal 200, last_response.status
    assert_equal 'OK', last_response.body
  end

  def test_webhook_sends_telegram_message
    payload = Fixtures::WebhookPayloads.card_published
    body = payload.to_json
    signature = Fixtures::WebhookPayloads.generate_signature(body, ENV['FIZZY_WEBHOOK_SECRET'])

    post '/webhook', body, {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_X_WEBHOOK_SIGNATURE' => signature
    }

    assert_requested(:post, /api.telegram.org/)
  end

  def test_webhook_rejects_invalid_signature
    payload = Fixtures::WebhookPayloads.card_published
    body = payload.to_json

    post '/webhook', body, {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_X_WEBHOOK_SIGNATURE' => 'invalid_signature'
    }

    assert_equal 401, last_response.status
    assert_equal 'Unauthorized', last_response.body
  end

  def test_webhook_rejects_missing_signature
    payload = Fixtures::WebhookPayloads.card_published
    body = payload.to_json

    post '/webhook', body, { 'CONTENT_TYPE' => 'application/json' }

    assert_equal 401, last_response.status
  end

  def test_webhook_handles_comment_created
    payload = Fixtures::WebhookPayloads.comment_created
    body = payload.to_json
    signature = Fixtures::WebhookPayloads.generate_signature(body, ENV['FIZZY_WEBHOOK_SECRET'])

    post '/webhook', body, {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_X_WEBHOOK_SIGNATURE' => signature
    }

    assert_equal 200, last_response.status
  end

  def test_webhook_handles_card_triaged
    payload = Fixtures::WebhookPayloads.card_triaged
    body = payload.to_json
    signature = Fixtures::WebhookPayloads.generate_signature(body, ENV['FIZZY_WEBHOOK_SECRET'])

    post '/webhook', body, {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_X_WEBHOOK_SIGNATURE' => signature
    }

    assert_equal 200, last_response.status
  end

  def test_webhook_handles_card_closed
    payload = Fixtures::WebhookPayloads.card_closed
    body = payload.to_json
    signature = Fixtures::WebhookPayloads.generate_signature(body, ENV['FIZZY_WEBHOOK_SECRET'])

    post '/webhook', body, {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_X_WEBHOOK_SIGNATURE' => signature
    }

    assert_equal 200, last_response.status
  end
end
