require 'rails_helper'

RSpec.describe ExpirePasswordJob, type: :job do
  let(:domain) { Domain.create!(name: 'example.com', password_expiration_frequency: 90) }
  let(:mailbox) { Mailbox.create!(username: 'user', password: 'password', domain: domain, scheduled_password_expiration: 1.hour.ago) }

  it 'updates passwords for expired email boxes and increases scheduled_password_expiration by 90 days' do
    expect {
      perform_enqueued_jobs { ExpirePasswordJob.perform_later }
    }.to change { mailbox.reload.password_digest }
     .and change { mailbox.scheduled_password_expiration }.by(90)
  end
end
