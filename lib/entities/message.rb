module Entities
  class Message
    attr_reader :chat_id, :text, :parse_mode

    def initialize(chat_id:, text:, parse_mode: 'HTML')
      @chat_id = chat_id
      @text = text
      @parse_mode = parse_mode
    end
  end
end