class CreateGroupInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :group_invitations do |t|
      t.integer :sent_by_id
      t.integer :user_id, null: false
      t.integer :group_id, null: false
      t.boolean :accepted?, default: false
      t.boolean :admin_approved?, default: false

      t.timestamps
    end

    add_index :group_invitations, :group_id
    add_index :group_invitations, :accepted?
    add_index :group_invitations, :admin_approved?
  end
end
