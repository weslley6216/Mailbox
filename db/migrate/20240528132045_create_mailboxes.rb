class CreateMailboxes < ActiveRecord::Migration[7.0]
  def change
    create_table :mailboxes do |t|
      t.references :domain, null: false, foreign_key: true
      t.string :username
      t.string :password
      t.date :scheduled_password_expiration

      t.timestamps
    end
  end
end
