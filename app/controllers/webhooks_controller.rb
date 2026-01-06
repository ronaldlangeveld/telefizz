class WebhooksController < ApplicationController
  allow_unauthenticated_access
  skip_forgery_protection

  def create
    board = Board.find_by(uuid: params[:uuid])
    if board.nil?
      head :not_found
      return
    end

    event_data = JSON.parse(request.body.read) rescue nil
    if event_data.nil?
      head :bad_request
      return
    end

    event = Entities::Event.new(
      id: event_data["id"],
      action: event_data["action"],
      created_at: event_data["created_at"],
      eventable: event_data["eventable"],
      board: event_data["board"],
      creator: event_data["creator"]
    )

    # Record the webhook event
    board.webhook_events.create!(action: event.action)

    # Process and send to all connected integrations
    ProcessWebhookEvent.new(board: board).execute(event)

    head :ok
  end
end
