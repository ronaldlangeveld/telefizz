require_relative '../test_helper'
require_relative '../fixtures/webhook_payloads'

class ProcessWebhookEventTest < Minitest::Test
  def setup
    @mock_gateway = MockMessageGateway.new
    @use_case = UseCases::ProcessWebhookEvent.new(message_gateway: @mock_gateway)
  end

  def test_card_published_message_format
    payload = Fixtures::WebhookPayloads.card_published
    event = build_event(payload)

    @use_case.execute(event)

    assert_equal 1, @mock_gateway.sent_messages.count
    message = @mock_gateway.sent_messages.first
    assert_equal ENV['TELEGRAM_CHAT_ID'], message.chat_id
    assert_equal 'HTML', message.parse_mode
    assert_includes message.text, '<b>Rob</b>'
    assert_includes message.text, 'created a new card'
    assert_includes message.text, '<a href="https://app.fizzy.do/6086023/cards/14">Test Card</a>'
  end

  def test_comment_created_message_format
    payload = Fixtures::WebhookPayloads.comment_created
    event = build_event(payload)

    @use_case.execute(event)

    message = @mock_gateway.sent_messages.first
    assert_includes message.text, '<b>Alice</b>'
    assert_includes message.text, 'commented'
    assert_includes message.text, '<i>looks great!</i>'
    assert_includes message.text, '<a href="https://app.fizzy.do/6086023/cards/14/comments/03f4xrj4hhdsths81108hkrh3">View comment</a>'
  end

  def test_card_triaged_message_format
    payload = Fixtures::WebhookPayloads.card_triaged
    event = build_event(payload)

    @use_case.execute(event)

    message = @mock_gateway.sent_messages.first
    assert_includes message.text, '<b>Bob</b>'
    assert_includes message.text, 'moved card'
    assert_includes message.text, '<b>In Progress</b>'
    assert_includes message.text, '<a href="https://app.fizzy.do/6086023/cards/15">Another Card</a>'
  end

  def test_card_closed_message_format
    payload = Fixtures::WebhookPayloads.card_closed
    event = build_event(payload)

    @use_case.execute(event)

    message = @mock_gateway.sent_messages.first
    assert_includes message.text, '<b>Charlie</b>'
    assert_includes message.text, 'closed card'
    assert_includes message.text, '<a href="https://app.fizzy.do/6086023/cards/16">Completed Task</a>'
  end

  def test_unknown_action_message_format
    payload = Fixtures::WebhookPayloads.card_published.merge('action' => 'unknown_action')
    event = build_event(payload)

    @use_case.execute(event)

    message = @mock_gateway.sent_messages.first
    assert_includes message.text, 'Unknown event'
    assert_includes message.text, 'unknown_action'
  end

  private

  def build_event(payload)
    Entities::Event.new(
      id: payload['id'],
      action: payload['action'],
      created_at: payload['created_at'],
      eventable: payload['eventable'],
      board: payload['board'],
      creator: payload['creator']
    )
  end
end

# Mock message gateway for testing
class MockMessageGateway
  attr_reader :sent_messages

  def initialize
    @sent_messages = []
  end

  def send_message(message)
    @sent_messages << message
  end
end
