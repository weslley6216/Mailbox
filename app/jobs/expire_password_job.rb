# frozen_string_literal: true

class ExpirePasswordJob < ApplicationJob
  queue_as :default

  def perform
    expired_mailboxes = Mailbox.where('scheduled_password_expiration <= ?', Time.current)

    expired_mailboxes.each do |mailbox|
      new_password = SecureRandom.hex(10)
      mailbox.update_password(new_password)
    end
  end
end
