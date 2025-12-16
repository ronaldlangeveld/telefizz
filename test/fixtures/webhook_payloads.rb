module Fixtures
  module WebhookPayloads
    def self.card_published
      {
        'id' => '03f4xqrrtyt3kcuccnhe17jbkrx',
        'action' => 'card_published',
        'created_at' => '2025-12-01T12:36:41.278Z',
        'eventable' => {
          'id' => '03f25q9qv0epc1bjiintxmver',
          'title' => 'Test Card',
          'status' => 'published',
          'image_url' => nil,
          'golden' => false,
          'last_active_at' => '2025-12-01T12:36:41.280Z',
          'created_at' => '2025-12-01T12:36:41.273Z',
          'url' => 'https://app.fizzy.do/6086023/cards/14'
        },
        'board' => {
          'id' => '03f25q9qe6193arwscdoc0htk',
          'name' => 'Test Board',
          'all_access' => false,
          'created_at' => '2025-11-06T02:52:46.688Z'
        },
        'creator' => {
          'id' => '03f25q9q7bw7t3206v9ttiy53',
          'name' => 'Rob',
          'role' => 'owner',
          'active' => true,
          'email_address' => 'user@example.com',
          'created_at' => '2025-11-18T17:25:14.054Z'
        }
      }
    end

    def self.comment_created
      {
        'id' => '03f4xrj4mhsez19bimn9lxh0a',
        'action' => 'comment_created',
        'created_at' => '2025-12-01T12:40:34.640Z',
        'eventable' => {
          'id' => '03f4xrj4hhdsths81108hkrh3',
          'title' => 'Test Card',
          'created_at' => '2025-12-01T12:40:34.612Z',
          'updated_at' => '2025-12-01T12:40:34.615Z',
          'url' => 'https://app.fizzy.do/6086023/cards/14/comments/03f4xrj4hhdsths81108hkrh3',
          'body' => {
            'plain_text' => 'looks great!',
            'html' => '<div class="action-text-content"><p>looks great!</p></div>'
          }
        },
        'board' => {
          'id' => '03f25q9qe6193arwscdoc0htk',
          'name' => 'Test Board',
          'all_access' => false,
          'created_at' => '2025-11-06T02:52:46.688Z'
        },
        'creator' => {
          'id' => '03f25q9q7bw7t3206v9ttiy53',
          'name' => 'Alice',
          'role' => 'member',
          'active' => true,
          'email_address' => 'alice@example.com',
          'created_at' => '2025-11-18T17:25:14.054Z'
        }
      }
    end

    def self.card_triaged
      {
        'id' => '03f4xrvu911qlv1f0917rz6g1',
        'action' => 'card_triaged',
        'created_at' => '2025-12-01T12:42:23.097Z',
        'eventable' => {
          'id' => '03f4xr8cgjq2rjailz64eig56',
          'title' => 'Another Card',
          'status' => 'published',
          'url' => 'https://app.fizzy.do/6086023/cards/15',
          'column' => {
            'id' => '03f25q9qmd7ywlzub1gecamkr',
            'name' => 'In Progress',
            'color' => {
              'name' => 'Blue',
              'value' => 'var(--color-card-default)'
            },
            'created_at' => '2025-11-06T02:53:56.791Z'
          }
        },
        'board' => {
          'id' => '03f25q9qe6193arwscdoc0htk',
          'name' => 'Test Board',
          'all_access' => false,
          'created_at' => '2025-11-06T02:52:46.688Z'
        },
        'creator' => {
          'id' => '03f25q9q7bw7t3206v9ttiy53',
          'name' => 'Bob',
          'role' => 'owner',
          'active' => true,
          'email_address' => 'bob@example.com',
          'created_at' => '2025-11-18T17:25:14.054Z'
        }
      }
    end

    def self.card_closed
      {
        'id' => '03f4xrxv6xr8nvgu7zh1l05m7s',
        'action' => 'card_closed',
        'created_at' => '2025-12-01T12:42:40.383Z',
        'eventable' => {
          'id' => '03f4xr8cgjq2rjailz64eig56',
          'title' => 'Completed Task',
          'status' => 'closed',
          'url' => 'https://app.fizzy.do/6086023/cards/16',
          'column' => {
            'id' => '03f25q9qnqjs53von00shkzm9',
            'name' => 'Done Column',
            'color' => {
              'name' => 'Pink',
              'value' => 'var(--color-card-8)'
            }
          }
        },
        'board' => {
          'id' => '03f25q9qe6193arwscdoc0htk',
          'name' => 'Test Board',
          'all_access' => false,
          'created_at' => '2025-11-06T02:52:46.688Z'
        },
        'creator' => {
          'id' => '03f25q9q7bw7t3206v9ttiy53',
          'name' => 'Charlie',
          'role' => 'member',
          'active' => true,
          'email_address' => 'charlie@example.com',
          'created_at' => '2025-11-18T17:25:14.054Z'
        }
      }
    end

    def self.generate_signature(payload, secret)
      require 'openssl'
      body = payload.is_a?(String) ? payload : payload.to_json
      OpenSSL::HMAC.hexdigest('SHA256', secret, body)
    end
  end
end
