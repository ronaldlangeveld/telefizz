require 'openssl'

module Interfaces
  class WebhookController
    def initialize(process_webhook_event_use_case:)
      @process_webhook_event_use_case = process_webhook_event_use_case
    end

    def handle_webhook(request_body, headers)
      signature = headers['X-Webhook-Signature']
      secret = ENV['FIZZY_WEBHOOK_SECRET']

      unless verify_signature(request_body, signature, secret)
        return { status: 401, body: 'Unauthorized' }
      end

      event_data = JSON.parse(request_body)
      event = Entities::Event.new(
        id: event_data['id'],
        action: event_data['action'],
        created_at: event_data['created_at'],
        eventable: event_data['eventable'],
        board: event_data['board'],
        creator: event_data['creator']
      )
      @process_webhook_event_use_case.execute(event)
      { status: 200, body: 'OK' }
    end

    private

    def verify_signature(body, signature, secret)
      return false unless signature && secret
      expected = OpenSSL::HMAC.hexdigest('SHA256', secret, body)
      OpenSSL.secure_compare(expected, signature)
    end
  end
end