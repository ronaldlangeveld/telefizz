class WebhooksController < ApplicationController
  allow_unauthenticated_access

  def create
    board = Board.find_by(uuid: params[:uuid])
    if board.nil?
      head :not_found
      return
    end

    event_data = JSON.parse(request_body) rescue nil
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

    # TODO Implement processing logic via ProcessWebhookEvent service

    # Process the webhook payload here
    # For example, you might want to log the payload or trigger some action

    head :ok
  end

  private
end
