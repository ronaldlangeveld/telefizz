require_relative '../test_helper'
require_relative '../fixtures/webhook_payloads'

class TelegramMessageGatewayTest < Minitest::Test
  def setup
    @gateway = Infrastructure::TelegramMessageGateway.new(bot_token: 'test_token')
  end

  def telegram_success_response
    {
      "ok" => true,
      "result" => {
        "message_id" => 123,
        "from" => {
          "id" => 1234567890,
          "is_bot" => true,
          "first_name" => "TestBot",
          "username" => "test_bot"
        },
        "chat" => {
          "id" => 123456789,
          "first_name" => "Test",
          "type" => "private"
        },
        "date" => 1734307200,
        "text" => "Hello, World!"
      }
    }.to_json
  end

  def test_send_message_calls_telegram_api
    stub_request(:post, "https://api.telegram.org/bottest_token/sendMessage")
      .with(
        body: { "chat_id" => "123456789", "text" => "Hello, World!", "parse_mode" => "HTML" }
      )
      .to_return(status: 200, body: telegram_success_response, headers: { 'Content-Type' => 'application/json' })

    message = Entities::Message.new(chat_id: '123456789', text: 'Hello, World!')
    
    # This should not raise an error
    @gateway.send_message(message)

    assert_requested(:post, "https://api.telegram.org/bottest_token/sendMessage")
  end

  def test_send_message_with_special_characters
    stub_request(:post, "https://api.telegram.org/bottest_token/sendMessage")
      .to_return(status: 200, body: telegram_success_response, headers: { 'Content-Type' => 'application/json' })

    message = Entities::Message.new(chat_id: '123456789', text: "Card 'Test' created by <User>")
    
    @gateway.send_message(message)

    assert_requested(:post, "https://api.telegram.org/bottest_token/sendMessage")
  end
end
