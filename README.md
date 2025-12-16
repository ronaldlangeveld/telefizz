# Fizzy Webhook Telegram Bot

A Ruby application using Clean Architecture that listens for Fizzy webhook events and sends notifications via Telegram bot.

## Setup

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Set environment variables:
   - `TELEGRAM_BOT_TOKEN`: Your Telegram bot token
   - `TELEGRAM_CHAT_ID`: The chat ID to send messages to
   - `FIZZY_WEBHOOK_SECRET`: Your Fizzy webhook secret for signature verification

3. Run the application:
   ```bash
   rackup
   ```

The app will listen on port 9292 by default.

## Testing

Run all tests:
```bash
bundle exec rake test
```

## Webhook Endpoint

POST `/webhook`

Expects JSON payload as per Fizzy webhooks documentation. The app verifies the `X-Webhook-Signature` header using HMAC-SHA256.

Supported events: card_published, card_board_changed, comment_created, card_assigned, card_unassigned, card_triaged, card_closed, card_reopened, card_postponed, card_sent_back_to_triage.

## Architecture

- **Entities**: Domain objects (Event, Message)
- **Use Cases**: Business logic (ProcessWebhookEvent)
- **Interfaces**: Controllers and gateways (WebhookController, MessageGateway)
- **Infrastructure**: External services (TelegramMessageGateway)