require_relative '../test_helper'

class EventTest < Minitest::Test
  def test_event_initialization
    event = Entities::Event.new(
      id: 'test-id',
      action: 'card_published',
      created_at: '2025-12-01T12:36:41.278Z',
      eventable: { 'title' => 'Test Card' },
      board: { 'name' => 'Test Board' },
      creator: { 'name' => 'Test User' }
    )

    assert_equal 'test-id', event.id
    assert_equal 'card_published', event.action
    assert_equal '2025-12-01T12:36:41.278Z', event.created_at
    assert_equal({ 'title' => 'Test Card' }, event.eventable)
    assert_equal({ 'name' => 'Test Board' }, event.board)
    assert_equal({ 'name' => 'Test User' }, event.creator)
  end

  def test_event_attributes_are_readable
    event = Entities::Event.new(
      id: 'id-123',
      action: 'comment_created',
      created_at: '2025-12-01T12:40:34.640Z',
      eventable: {},
      board: {},
      creator: {}
    )

    assert_respond_to event, :id
    assert_respond_to event, :action
    assert_respond_to event, :created_at
    assert_respond_to event, :eventable
    assert_respond_to event, :board
    assert_respond_to event, :creator
  end
end
