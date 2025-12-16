require_relative '../test_helper'

class MessageTest < Minitest::Test
  def test_message_initialization
    message = Entities::Message.new(
      chat_id: '123456789',
      text: 'Hello, World!'
    )

    assert_equal '123456789', message.chat_id
    assert_equal 'Hello, World!', message.text
    assert_equal 'HTML', message.parse_mode
  end

  def test_message_with_custom_parse_mode
    message = Entities::Message.new(
      chat_id: '123456789',
      text: 'Hello',
      parse_mode: 'Markdown'
    )

    assert_equal 'Markdown', message.parse_mode
  end

  def test_message_attributes_are_readable
    message = Entities::Message.new(chat_id: '999', text: 'Test')

    assert_respond_to message, :chat_id
    assert_respond_to message, :text
    assert_respond_to message, :parse_mode
  end
end
