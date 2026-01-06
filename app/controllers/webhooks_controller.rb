class WebhooksController < ApplicationController
  allow_unauthenticated_access
  skip_forgery_protection

  def create
    board = Board.find_by(uuid: params[:uuid])
    if board.nil?
      Rails.logger.warn("Webhook received for unknown board UUID: #{params[:uuid]}")
      head :not_found
      return
    end

    event_data = JSON.parse(request.body.read) rescue nil
    if event_data.nil?
      head :bad_request
      return
    end

    # Fizzy sends action in the nested webhook object or as a separate field
    action = event_data["action"] || event_data.dig("webhook", "action")

    Rails.logger.info("Webhook received for board #{board.name}: action=#{action}")
    Rails.logger.info("Board has #{board.integrations.count} integrations connected")

    event = Entities::Event.new(
      id: event_data["id"],
      action: action,
      created_at: event_data["created_at"],
      eventable: event_data["eventable"],
      board: event_data["board"],
      creator: event_data["creator"]
    )

    # Record the webhook event
    board.webhook_events.create!(action: event.action)

    # Process and send to all connected integrations
    results = ProcessWebhookEvent.new(board: board).execute(event)
    Rails.logger.info("Webhook processing results: #{results.inspect}")

    head :ok
  end
end
