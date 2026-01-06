class CreateBoardIntegrations < ActiveRecord::Migration[8.1]
  def change
    create_table :board_integrations do |t|
      t.references :board, null: false, foreign_key: true
      t.references :integration, null: false, foreign_key: true

      t.timestamps
    end
  end
end
