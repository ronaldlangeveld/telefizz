class ProcessWebhookEvent
    EVENT_FORMATS = {
      "card_published" => { emoji: "📝", action: "created a new card" },
      "card_board_changed" => { emoji: "📋", action: "moved card to board", include_board: true },
      "card_assigned" => { emoji: "👤", action: "assigned card" },
      "card_unassigned" => { emoji: "👤", action: "unassigned card" },
      "card_triaged" => { emoji: "🔀", action: "moved card to", include_column: true },
      "card_closed" => { emoji: "✅", action: "closed card" },
      "card_reopened" => { emoji: "🔄", action: "reopened card" },
      "card_postponed" => { emoji: "⏸️", action: "postponed card" },
      "card_sent_back_to_triage" => { emoji: "↩️", action: "sent card back to triage" }
    }.freeze

    def initialize(message_gateway:)
      @message_gateway = message_gateway
    end

    def execute(event)
      message_text = format_message(event)
      message = Entities::Message.new(chat_id: ENV["TELEGRAM_CHAT_ID"], text: message_text)
      @message_gateway.send_message(message)
    end

    private

    def format_message(event)
      creator_name = escape_html(event.creator["name"])

      case event.action
      when "comment_created"
        format_comment(event, creator_name)
      when *EVENT_FORMATS.keys
        format_card_event(event, creator_name)
      else
        "⚠️ Unknown event: <code>#{escape_html(event.action)}</code> by <b>#{creator_name}</b>"
      end
    end

    def format_card_event(event, creator_name)
      config = EVENT_FORMATS[event.action]
      card_title = escape_html(event.eventable["title"])
      card_url = event.eventable["url"]

      action_text = build_action_text(event, config, creator_name)

      "#{config[:emoji]} #{action_text}\n\n<a href=\"#{card_url}\">#{card_title}</a>"
    end

    def build_action_text(event, config, creator_name)
      text = "<b>#{creator_name}</b> #{config[:action]}"

      if config[:include_board]
        board_name = escape_html(event.board["name"])
        text += " <b>#{board_name}</b>"
      elsif config[:include_column]
        column_name = escape_html(event.eventable["column"]["name"])
        text += " <b>#{column_name}</b>"
      end

      text
    end

    def format_comment(event, creator_name)
      comment_body = escape_html(event.eventable["body"]["plain_text"])
      comment_url = event.eventable["url"]

      "💬 <b>#{creator_name}</b> commented:\n\n" \
        "<i>#{comment_body}</i>\n\n" \
        "<a href=\"#{comment_url}\">View comment</a>"
    end

    def escape_html(text)
      return "" if text.nil?
      text.to_s
          .gsub("&", "&amp;")
          .gsub("<", "&lt;")
          .gsub(">", "&gt;")
    end
end
