require_relative '../test_helper'
require_relative '../fixtures/webhook_payloads'

class WebhookControllerTest < Minitest::Test
  def setup
    @mock_use_case = MockProcessWebhookEventUseCase.new
    @controller = Interfaces::WebhookController.new(process_webhook_event_use_case: @mock_use_case)
  end

  def test_valid_webhook_returns_200
    payload = Fixtures::WebhookPayloads.card_published
    body = payload.to_json
    signature = Fixtures::WebhookPayloads.generate_signature(body, ENV['FIZZY_WEBHOOK_SECRET'])
    headers = { 'X-Webhook-Signature' => signature }

    response = @controller.handle_webhook(body, headers)

    assert_equal 200, response[:status]
    assert_equal 'OK', response[:body]
  end

  def test_valid_webhook_executes_use_case
    payload = Fixtures::WebhookPayloads.card_published
    body = payload.to_json
    signature = Fixtures::WebhookPayloads.generate_signature(body, ENV['FIZZY_WEBHOOK_SECRET'])
    headers = { 'X-Webhook-Signature' => signature }

    @controller.handle_webhook(body, headers)

    assert_equal 1, @mock_use_case.executed_events.count
    event = @mock_use_case.executed_events.first
    assert_equal 'card_published', event.action
    assert_equal 'Test Card', event.eventable['title']
  end

  def test_invalid_signature_returns_401
    payload = Fixtures::WebhookPayloads.card_published
    body = payload.to_json
    headers = { 'X-Webhook-Signature' => 'invalid_signature' }

    response = @controller.handle_webhook(body, headers)

    assert_equal 401, response[:status]
    assert_equal 'Unauthorized', response[:body]
  end

  def test_missing_signature_returns_401
    payload = Fixtures::WebhookPayloads.card_published
    body = payload.to_json
    headers = {}

    response = @controller.handle_webhook(body, headers)

    assert_equal 401, response[:status]
    assert_equal 'Unauthorized', response[:body]
  end

  def test_use_case_not_executed_on_invalid_signature
    payload = Fixtures::WebhookPayloads.card_published
    body = payload.to_json
    headers = { 'X-Webhook-Signature' => 'wrong_signature' }

    @controller.handle_webhook(body, headers)

    assert_equal 0, @mock_use_case.executed_events.count
  end

  def test_parses_all_event_fields_correctly
    payload = Fixtures::WebhookPayloads.card_triaged
    body = payload.to_json
    signature = Fixtures::WebhookPayloads.generate_signature(body, ENV['FIZZY_WEBHOOK_SECRET'])
    headers = { 'X-Webhook-Signature' => signature }

    @controller.handle_webhook(body, headers)

    event = @mock_use_case.executed_events.first
    assert_equal payload['id'], event.id
    assert_equal payload['action'], event.action
    assert_equal payload['created_at'], event.created_at
    assert_equal payload['eventable'], event.eventable
    assert_equal payload['board'], event.board
    assert_equal payload['creator'], event.creator
  end
end

# Mock use case for testing
class MockProcessWebhookEventUseCase
  attr_reader :executed_events

  def initialize
    @executed_events = []
  end

  def execute(event)
    @executed_events << event
  end
end
