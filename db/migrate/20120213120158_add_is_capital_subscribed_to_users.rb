class AddIsCapitalSubscribedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_capital_subscribed, :boolean, default: true
  end

  def self.down
    remove_column :users, :is_capital_subscribed
  end
end
