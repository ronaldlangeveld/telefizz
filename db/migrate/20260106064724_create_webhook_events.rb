class CreateWebhookEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_events do |t|
      t.string :action
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
