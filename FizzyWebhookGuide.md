# Fizzy Webhooks Documentation

This document describes the webhook payload structure for Fizzy (https://app.fizzy.do).

## Overview

Fizzy sends HTTP POST requests to your configured webhook URL when certain events occur. Each request includes a signature header for verification.

## Authentication

### Headers

| Header              | Description                              |
|---------------------|------------------------------------------|
| X-Webhook-Signature | HMAC-SHA256 signature of the request body |
| X-Webhook-Timestamp | ISO 8601 timestamp of when the webhook was sent |
| Content-Type        | application/json                         |
| User-Agent          | fizzy/1.0.0 webhook                      |

## Signature Verification

To verify the webhook signature:

1. Get your webhook secret from Fizzy settings

2. Compute HMAC-SHA256 of the raw request body using your secret

3. Compare the result with the `X-Webhook-Signature` header

### Ruby Example:

```ruby
require 'openssl'

def verify_signature(body, signature, secret)
  expected = OpenSSL::HMAC.hexdigest('SHA256', secret, body)
  OpenSSL.secure_compare(expected, signature)
end
```

### JavaScript Example:

```javascript
const crypto = require('crypto');

function verifySignature(body, signature, secret) {
  const expected = crypto.createHmac('sha256', secret).update(body).digest('hex');
  return crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(signature));
}
```

# Payload Structure

All webhook payloads share a common structure:

```json
{
  "id": "unique_event_id",
  "action": "event_type",
  "created_at": "2025-12-01T12:36:41.278Z",
  "eventable": { ... },
  "board": { ... },
  "creator": { ... }
}
```

## Common Fields

| Field      | Type    | Description                              |
|------------|---------|------------------------------------------|
| id         | string  | Unique identifier for this webhook event |
| action     | string  | The type of event (see Event Types below) |
| created_at | string  | ISO 8601 timestamp of when the event occurred |
| eventable  | object  | The primary object affected by the event (Card or Comment) |
| board      | object  | The board where the event occurred       |
| creator    | object  | The user who triggered the event         |

## Event Types

| Action                  | UI Trigger                  | Description                              |
|-------------------------|-----------------------------|------------------------------------------|
| card_published          | Card added                  | A new card was created                   |
| card_board_changed      | Card board changed          | Card was moved to a different board      |
| comment_created         | Comment added               | A comment was added to a card            |
| card_assigned           | Card assigned               | Card was assigned to a user              |
| card_unassigned         | Card unassigned             | Card was unassigned from a user          |
| card_triaged            | Card column changed         | Card was moved to a column               |
| card_closed             | Card moved to "Done"        | Card was marked as complete              |
| card_reopened           | Card reopened               | Card was reopened from Done              |
| card_postponed          | Card moved to "Not Now"     | Card was manually postponed              |
| card_postponed          | Card moved to "Not Now" due to inactivity | Card was auto-postponed (same action)    |
| card_sent_back_to_triage| Card moved back to "Maybe?" | Card was sent back to triage             |

## Object Schemas

### User Object

```json
{
  "id": "03f25q9q7bw7t3206v9ttiy53",
  "name": "Rob",
  "role": "owner",
  "active": true,
  "email_address": "user@example.com",
  "created_at": "2025-11-18T17:25:14.054Z",
  "url": "https://app.fizzy.do/6086023/users/03f25q9q7bw7t3206v9ttiy53"
}
```

| Field         | Type    | Description                              |
|---------------|---------|------------------------------------------|
| id            | string  | Unique user identifier                   |
| name          | string  | Display name                             |
| role          | string  | User role (e.g., "owner")                |
| active        | boolean | Whether the user is active               |
| email_address | string  | User's email address                     |
| created_at    | string  | ISO 8601 timestamp                       |
| url           | string  | URL to user profile                      |

### Board Object

```json
{
  "id": "03f25q9qe6193arwscdoc0htk",
  "name": "Test",
  "all_access": false,
  "created_at": "2025-11-06T02:52:46.688Z",
  "creator": { ... }
}
```

| Field      | Type    | Description                              |
|------------|---------|------------------------------------------|
| id         | string  | Unique board identifier                  |
| name       | string  | Board name                               |
| all_access | boolean | Whether board is accessible to all       |
| created_at | string  | ISO 8601 timestamp                       |
| creator    | object  | User who created the board               |

## Card Object (eventable)

```json
{
  "id": "03f25q9qv6epc1bj1intxmver",
  "title": "Card title",
  "status": "published",
  "image_url": null,
  "golden": false,
  "last_active_at": "2025-12-01T12:36:41.280Z",
  "created_at": "2025-12-01T12:36:41.273Z",
  "url": "https://app.fizzy.do/6086023/cards/14",
  "board": { ... },
  "column": { ... },
  "creator": { ... }
}
```

| Field          | Type       | Description                              |
|----------------|------------|------------------------------------------|
| id             | string     | Unique card identifier                   |
| title          | string     | Card title                               |
| status         | string     | Card status (e.g., "published")          |
| image_url      | string\|null | URL to card image if present             |
| golden         | boolean    | Whether card is marked as golden         |
| last_active_at | string     | ISO 8601 timestamp of last activity      |
| created_at     | string     | ISO 8601 timestamp                       |
| url            | string     | URL to view the card                     |
| board          | object     | Board the card belongs to                |
| column         | object     | Column the card is in (only for triaged/closed/reopened events) |
| creator        | object     | User who created the card                |

Column Object

Present on `card_triaged`, `card_closed`, and `card_reopened` events:

```json
{
  "id": "03f25q9qmd7yw1zub1gecamkr",
  "name": "In Progress",
  "color": {
    "name": "Blue",
    "value": "var(--color-card-default)"
  },
  "created_at": "2025-11-06T02:53:56.791Z"
}
```

| Field      | Type    | Description                              |
|------------|---------|------------------------------------------|
| id         | string  | Unique column identifier                 |
| name       | string  | Column name                              |
| color      | object  | Column color settings                    |
| color.name | string  | Color name (e.g., "Blue", "Pink")        |
| color.value| string  | CSS variable for the color               |
| created_at | string  | ISO 8601 timestamp                       |

Comment Object (eventable)

For `comment_created` events:

```json
{
  "id": "03f4xrj4hhdsths81u08hkrh3",
  "created_at": "2025-12-01T12:40:34.612Z",
  "updated_at": "2025-12-01T12:40:34.615Z",
  "body": {
    "plain_text": "looks great!",
    "html": "<div class=\"action-text-content\"><p>Looks great!</p></div>"
  },
  "creator": { ... },
  "reactions_url": "https://app.fizzy.do/.../reactions",
  "url": "https://app.fizzy.do/.../comments/..."
}
```

| Field           | Type    | Description                              |
|-----------------|---------|------------------------------------------|
| id              | string  | Unique comment identifier                |
| created_at      | string  | ISO 8601 timestamp                       |
| updated_at      | string  | ISO 8601 timestamp                       |
| body            | object  | Comment content                          |
| body.plain_text | string  | Plain text version                       |
| body.html       | string  | HTML formatted version                   |
| creator         | object  | User who created the comment             |
| reactions_url   | string  | URL for comment reactions                |
| url             | string  | URL to the comment                       |

## Event Payload Examples

### card_published

Triggered when a new card is created.

```json
{
  "id": "03f4xqrrtyt3kcuccnhe17jbkrx",
  "action": "card_published",
  "created_at": "2025-12-01T12:36:41.278Z",
  "eventable": {
    "id": "03f25q9qv0epc1bjiintxmver",
    "title": "adding card",
    "status": "published",
    "image_url": null,
    "golden": false,
    "last_active_at": "2025-12-01T12:36:41.280Z",
    "created_at": "2025-12-01T12:36:41.273Z",
    "url": "https://app.fizzy.do/6086023/cards/14",
    "board": { ... },
    "creator": { ... }
  },
  "board": { ... },
  "creator": { ... }
}
```

### comment_created

Triggered when a comment is added to a card.

```json
{
  "id": "03f4xrj4mhsez19bimn9lxh0a",
  "action": "comment_created",
  "created_at": "2025-12-01T12:40:34.640Z",
  "eventable": {
    "id": "03f4xrj4hhdsths81108hkrh3",
    "created_at": "2025-12-01T12:40:34.612Z",
    "updated_at": "2025-12-01T12:40:34.615Z",
    "body": {
      "plain_text": "looks great!",
      "html": "<div class=\"action-text-content\"><p>looks great!</p></div>\n"
    },
    "creator": { ... },
    "reactions_url": "https://app.fizzy.do/.../reactions",
    "url": "https://app.fizzy.do/.../comments/..."
  },
  "board": { ... },
  "creator": { ... }
}
```

card_board_changed

Triggered when a card is moved to a different board.

```json
{
  "id": "03f4xrrvefiolce4507k6gpk8",
  "action": "card_board_changed",
  "created_at": "2025-12-01T12:41:49.240Z",
  "eventable": {
    "id": "03f4xr8cgjg2rja1lz64eig56",
    "title": "adding another card",
    "status": "published",
    ...
  },
  "board": { ... },
  "creator": { ... }
}
```

card_assigned / card_unassigned

Triggered when a card is assigned to or unassigned from a user.

```json
{
  "id": "03f4xrv7pqb9jmcmoip1eb5o5",
  "action": "card_assigned",
  "created_at": "2025-12-01T12:42:17.754Z",
  "eventable": { ... },
  "board": { ... },
  "creator": { ... }
}
```

card_triaged

Triggered when a card is moved to a column.

```json
{
  "id": "03f4xrvu911qlv1f0917rz6g1",
  "action": "card_triaged",
  "created_at": "2025-12-01T12:42:23.097Z",
  "eventable": {
    "id": "03f4xr8cgjq2r jailz64eig56",
    "title": "adding another card",
    "status": "published",
    ...
    "column": {
      "id": "03f25q9qmd7ywlzub1gecamkr",
      "name": "In Progress",
      "color": {
        "name": "Blue",
        "value": "var(--color-card-default)"
      },
      "created_at": "2025-11-06T02:53:56.791Z"
    },
    ...
  },
  "board": { ... },
  "creator": { ... }
}
```

card_closed

Triggered when a card is moved to "Done".

```json
{
  "id": "03f4xrxv6xr8nvgu7zh1l05m7s",
  "action": "card_closed",
  "created_at": "2025-12-01T12:42:40.383Z",
  "eventable": {
    ...
    "column": {
      "id": "03f25q9qnqjs53von00shkzm9",
      "name": "Done Column",
      "color": {
        "name": "Pink",
        "value": "var(--color-card-8)"
      },
      ...
    },
    ...
  },
  "board": { ... },
  "creator": { ... }
}
```

card_reopened

Triggered when a card is reopened from Done.

```json
{
  "id": "03f4xryfjk0m8p7gaqriw1bh7",
  "action": "card_reopened",
  "created_at": "2025-12-01T12:42:45.205Z",
  "eventable": {
    ...
    "column": { ... },
    ...
  },
  "board": { ... },
  "creator": { ... }
}
```

card_postponed

Triggered when a card is moved to "Not Now" (manually or due to inactivity).

```json
{
  "id": "03f4xrz6kha05vrrjus8bd8en",
  "action": "card_postponed",
  "created_at": "2025-12-01T12:42:51.610Z",
  "eventable": { ... },
  "board": { ... },
  "creator": { ... }
}
```

card_sent_back_to_triage

Triggered when a card is moved back to "Maybe?".

```json
{
  "id": "03f4xs06boipsjldciuz3yx1r",
  "action": "card_sent_back_to_triage",
  "created_at": "2025-12-01T12:43:00.084Z",
  "eventable": { ... },
  "board": { ... },
  "creator": { ... }
}
```

Limitations

* Card body/content not included - The card object in webhook payloads only includes the title, not the full body/description content. Comments include both plain_text and html in their body field, but cards do not. Since Fizzy doesn't currently have a public API, there's no way to fetch the full card content programmatically - you'll need to use the `url` field to view the card manually in the browser.

## Best Practices

1. **Always verify signatures** - Use timing-safe comparison to prevent timing attacks

2. **Respond quickly** - Return a 2xx status code promptly; process webhooks asynchronously if needed

3. **Handle duplicates** - Use the event `id` to deduplicate if you receive the same event twice

4. **Log failures** - Keep track of failed webhook deliveries for debugging