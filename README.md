# Telefizz 🤖

> A production-ready webhook relay that transforms Fizzy notifications into Telegram messages using Clean Architecture principles.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ruby: 3.3+](https://img.shields.io/badge/Ruby-3.3+-CC342D)](https://www.ruby-lang.org/)
[![Deployed with Kamal](https://img.shields.io/badge/Deployed%20with-Kamal-4169E1)](https://kamal-deploy.org/)

## Overview

Telefizz listens for webhook events from [Fizzy](https://fizzy.do/) and instantly relays them to Telegram. Built with Clean Architecture for maintainability, it's designed to be self-hosted, scalable, and easy to understand.

Perfect for teams that want real-time Fizzy notifications without context-switching.

## Features

✨ **Real-time Notifications** - Instant Telegram alerts for Fizzy events  
🔒 **Secure** - HMAC-SHA256 signature verification for webhook authenticity  
🏗️ **Clean Architecture** - Well-organized, testable, and maintainable codebase  
🐳 **Containerized** - Production-ready Docker setup with Kamal deployment  
🚀 **Zero-Downtime Deploys** - Automatic rolling updates via Kamal  
✅ **Health Checks** - Built-in `/up` endpoint for monitoring  

## Supported Events

- 📌 Card Published
- 📋 Card Board Changed
- 💬 Comment Created
- 👤 Card Assigned / Unassigned
- 🏷️ Card Triaged
- ✅ Card Closed / Reopened
- ⏸️ Card Postponed
- 🔄 Card Sent Back to Triage

## Quick Start

### Local Development

1. **Clone and install dependencies:**
   ```bash
   git clone <repository>
   cd telefizz
   bundle install
   ```

2. **Configure environment variables:**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` with your credentials:
   ```env
   TELEGRAM_BOT_TOKEN=your_bot_token_here
   TELEGRAM_CHAT_ID=your_chat_id_here
   FIZZY_WEBHOOK_SECRET=your_webhook_secret_here
   ```

3. **Run the application:**
   ```bash
   ruby app.rb
   ```
   
   The app will be available at `http://localhost:9292`

4. **Run tests:**
   ```bash
   bundle exec rake test
   ```

### API Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/up` | Health check (returns 200 OK) |
| `POST` | `/webhook` | Fizzy webhook receiver |

## Deployment with Kamal

Telefizz is production-ready with [Kamal](https://kamal-deploy.org/), a zero-downtime deployment tool for containerized applications.

### Prerequisites

- Docker installed on your deployment server
- SSH access to your server
- A domain name with DNS pointing to your server

### Setup

1. **Install Kamal:**
   ```bash
   gem install kamal
   ```

2. **Configure deployment:**
   
   Edit `config/deploy.yml`:
   - Update `servers.web` with your server IP (or set `SERVER_IP` in `.env`)
   - Update `proxy.host` with your domain (or set `APP_HOST` in `.env`)
   - Configure registry credentials if using a private registry

3. **Create `.env` file with your secrets:**
   ```bash
   cp .env.example .env
   # Edit .env with actual values
   ```
   
   > **💡 Tip:** We recommend using the [dotenv gem](https://github.com/bkeepers/dotenv) for to easily handle your credentials. Install it globally and use `dotenv kamal setup` instead of `kamal setup` to automatically load your `.env` file. Of course, you can also use a Password Manager as per Kamals Documentation.

4. **Deploy:**
   ```bash
   # With dotenv
   dotenv kamal setup     # First-time setup
   dotenv kamal deploy    # Deploy your app
   
   # Or without dotenv
   kamal setup
   kamal deploy
   ```

### Kamal Commands

```bash
# View deployment status
kamal status

# View container logs
kamal logs

# Execute a command in the container
kamal app exec "command"

# Rollback to previous version
kamal rollback

# Stop the application
kamal stop

# Start the application
kamal start

# Redeploy current version
kamal redeploy
```

### SSL/TLS

Kamal automatically provisions free SSL certificates via Let's Encrypt. Update `config/deploy.yml`:

```yaml
proxy:
  ssl: true
  host: your-domain.com
```

## Architecture

Telefizz follows Clean Architecture principles for maximum maintainability:

```
lib/
├── entities/              # Domain objects
│   ├── event.rb          # Webhook event representation
│   └── message.rb        # Telegram message representation
├── use_cases/            # Business logic
│   └── process_webhook_event.rb
├── interfaces/           # Controllers and gateways
│   ├── webhook_controller.rb
│   └── gateways/
│       └── message_gateway.rb
└── infrastructure/       # External services
    └── telegram_message_gateway.rb
```

### Key Concepts

- **Entities**: Pure domain objects with no external dependencies
- **Use Cases**: Application business logic, independent of delivery mechanism
- **Interfaces**: Controllers (HTTP handlers) and gateway interfaces
- **Infrastructure**: Concrete implementations of external integrations (Telegram API)

This structure allows you to:
- Test business logic without HTTP or external service mocking
- Easily swap implementations (e.g., different notification services)
- Understand the codebase at a glance

## Development

### Running Tests

```bash
bundle exec rake test
```

### Project Structure

```
telefizz/
├── app.rb                 # Sinatra application entry point
├── config.ru              # Rack configuration
├── Gemfile               # Ruby dependencies
├── Gemfile.lock          # Locked dependency versions
├── Dockerfile            # Production container definition
├── config/
│   └── deploy.yml        # Kamal deployment configuration
├── lib/                  # Application code
└── test/                 # Test files
```

## Configuration Reference

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `TELEGRAM_BOT_TOKEN` | ✅ | Your Telegram bot token from [@BotFather](https://t.me/botfather) |
| `TELEGRAM_CHAT_ID` | ✅ | Chat ID where messages will be sent |
| `FIZZY_WEBHOOK_SECRET` | ✅ | Secret key for webhook signature verification |
| `SERVER_IP` | (Kamal) | IP address of your deployment server |
| `APP_HOST` | (Kamal) | Domain name for your app |

### Kamal Configuration

See `config/deploy.yml` for all available options. Key settings:

- **`servers.web`**: Your deployment server(s)
- **`proxy.host`**: Your domain name
- **`proxy.ssl`**: Enable HTTPS (default: true)
- **`env.secret`**: Environment variables to inject into containers

## Monitoring

The `/up` endpoint provides a health check for monitoring solutions:

```bash
curl https://your-domain.com/up
# Returns: 200 OK
```

Use this with Kamal's health checks, monitoring services, or load balancers to ensure your app stays running.

## Security

- ✅ Webhook signatures verified via HMAC-SHA256
- ✅ Runs as non-root user in container
- ✅ Environment secrets never committed to git
- ✅ SSL/TLS encryption enabled by default

## Troubleshooting

### Webhook not receiving events
1. Verify `FIZZY_WEBHOOK_SECRET` matches your Fizzy webhook configuration
2. Check logs: `kamal logs`
3. Test webhook manually with cURL

### SSL Certificate issues
Kamal automatically handles Let's Encrypt certificates. If issues persist:
```bash
kamal redeploy  # Restart to refresh certificates
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or suggestions, please open an [issue](https://github.com/ronaldlangeveld/telefizz/issues) on GitHub.

---

**Made with ❤️ for real-time notifications**
