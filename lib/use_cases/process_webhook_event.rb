module UseCases
  class ProcessWebhookEvent
    def initialize(message_gateway:)
      @message_gateway = message_gateway
    end

    def execute(event)
      message_text = format_message(event)
      message = Entities::Message.new(chat_id: ENV['TELEGRAM_CHAT_ID'], text: message_text)
      @message_gateway.send_message(message)
    end

    private

    def format_message(event)
      creator_name = escape_html(event.creator['name'])
      board_name = escape_html(event.board['name'])

      case event.action
      when 'card_published'
        card_title = escape_html(event.eventable['title'])
        card_url = event.eventable['url']
        "📝 <b>#{creator_name}</b> created a new card\n\n" \
          "<a href=\"#{card_url}\">#{card_title}</a>"
      when 'card_board_changed'
        card_title = escape_html(event.eventable['title'])
        card_url = event.eventable['url']
        "📋 <b>#{creator_name}</b> moved card to board <b>#{board_name}</b>\n\n" \
          "<a href=\"#{card_url}\">#{card_title}</a>"
      when 'comment_created'
        comment_body = escape_html(event.eventable['body']['plain_text'])
        comment_url = event.eventable['url']
        "💬 <b>#{creator_name}</b> commented:\n\n" \
          "<i>#{comment_body}</i>\n\n" \
          "<a href=\"#{comment_url}\">View comment</a>"
      when 'card_assigned'
        card_title = escape_html(event.eventable['title'])
        card_url = event.eventable['url']
        "👤 <b>#{creator_name}</b> assigned card\n\n" \
          "<a href=\"#{card_url}\">#{card_title}</a>"
      when 'card_unassigned'
        card_title = escape_html(event.eventable['title'])
        card_url = event.eventable['url']
        "👤 <b>#{creator_name}</b> unassigned card\n\n" \
          "<a href=\"#{card_url}\">#{card_title}</a>"
      when 'card_triaged'
        card_title = escape_html(event.eventable['title'])
        card_url = event.eventable['url']
        column_name = escape_html(event.eventable['column']['name'])
        "🔀 <b>#{creator_name}</b> moved card to <b>#{column_name}</b>\n\n" \
          "<a href=\"#{card_url}\">#{card_title}</a>"
      when 'card_closed'
        card_title = escape_html(event.eventable['title'])
        card_url = event.eventable['url']
        "✅ <b>#{creator_name}</b> closed card\n\n" \
          "<a href=\"#{card_url}\">#{card_title}</a>"
      when 'card_reopened'
        card_title = escape_html(event.eventable['title'])
        card_url = event.eventable['url']
        "🔄 <b>#{creator_name}</b> reopened card\n\n" \
          "<a href=\"#{card_url}\">#{card_title}</a>"
      when 'card_postponed'
        card_title = escape_html(event.eventable['title'])
        card_url = event.eventable['url']
        "⏸️ <b>#{creator_name}</b> postponed card\n\n" \
          "<a href=\"#{card_url}\">#{card_title}</a>"
      when 'card_sent_back_to_triage'
        card_title = escape_html(event.eventable['title'])
        card_url = event.eventable['url']
        "↩️ <b>#{creator_name}</b> sent card back to triage\n\n" \
          "<a href=\"#{card_url}\">#{card_title}</a>"
      else
        "⚠️ Unknown event: <code>#{escape_html(event.action)}</code> by <b>#{creator_name}</b>"
      end
    end

    def escape_html(text)
      return '' if text.nil?
      text.to_s
          .gsub('&', '&amp;')
          .gsub('<', '&lt;')
          .gsub('>', '&gt;')
    end
  end
end