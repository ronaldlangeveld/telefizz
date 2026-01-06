class AddNameToIntegrations < ActiveRecord::Migration[8.1]
  def change
    add_column :integrations, :name, :string
  end
end
