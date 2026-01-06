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

  def initialize(board:)
    @board = board
  end

  def execute(event)
    message_text = format_message(event)
    results = {}

    @board.integrations.each do |integration|
      formatted = integration.format_message(message_text)
      results[integration.id] = integration.send_message(formatted)
    end

    results
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
      "⚠️ Unknown event: #{escape_html(event.action)} by #{creator_name}"
    end
  end

  def format_card_event(event, creator_name)
    config = EVENT_FORMATS[event.action]
    card_title = escape_html(event.eventable["title"])
    card_url = event.eventable["url"]

    action_text = build_action_text(event, config, creator_name)

    "#{config[:emoji]} #{action_text}\n\n#{card_title}\n#{card_url}"
  end

  def build_action_text(event, config, creator_name)
    text = "#{creator_name} #{config[:action]}"

    if config[:include_board]
      board_name = escape_html(event.board["name"])
      text += " #{board_name}"
    elsif config[:include_column]
      column_name = escape_html(event.eventable["column"]["name"])
      text += " #{column_name}"
    end

    text
  end

  def format_comment(event, creator_name)
    comment_body = escape_html(event.eventable["body"]["plain_text"])
    comment_url = event.eventable["url"]

    "💬 #{creator_name} commented:\n\n#{comment_body}\n\n#{comment_url}"
  end

  def escape_html(text)
    return "" if text.nil?
    text.to_s
        .gsub("&", "&amp;")
        .gsub("<", "&lt;")
        .gsub(">", "&gt;")
  end
end
