class CreateIntegrations < ActiveRecord::Migration[8.1]
  def change
    create_table :integrations do |t|
      t.string :type
      t.json :config
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
