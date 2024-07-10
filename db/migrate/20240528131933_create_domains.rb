# frozen_string_literal: true

class CreateDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :domains do |t|
      t.string :name
      t.integer :password_expiration_frequency

      t.timestamps
    end
  end
end
