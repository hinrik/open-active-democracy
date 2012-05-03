class RenameDeletedAtToRemovedAt < ActiveRecord::Migration
  def change
    [:notifications, :partners, :priorities, :messages, :users].each do |table|
      rename_column table, :deleted_at, :removed_at
    end
  end
end
