# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mailbox, type: :model do
  let(:domain) { Domain.create!(name: 'example.com', password_expiration_frequency: 90) }
  let(:mailbox) { Mailbox.create!(username: 'user', password: 'password', domain:, scheduled_password_expiration: 30.days.from_now) }

  describe 'associations' do
    it { should belong_to(:domain) }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:scheduled_password_expiration) }
  end

  describe 'callbacks' do
    let(:mailbox) { Mailbox.new(username: 'user', password: 'password', domain:, scheduled_password_expiration: 30.days.from_now) }

    it 'hashes the password before validation' do
      mailbox.valid?

      expect(mailbox.password).to_not eq('password')
      expect(mailbox.password).to eq(Digest::SHA512.hexdigest('password'))
    end

    it 'sets scheduled_password_expiration before validation on create' do
      mailbox.scheduled_password_expiration = nil

      mailbox.valid?

      expect(mailbox.scheduled_password_expiration).to eq((Time.current + domain.password_expiration_frequency.days).to_date)
    end
  end

  describe '#update_password' do
    it 'updates the password and scheduled_password_expiration' do
      mailbox.update_password('new_password')

      expect(mailbox.password).to_not eq('new_password')
      expect(mailbox.password).to eq(Digest::SHA512.hexdigest('new_password'))
      expect(mailbox.scheduled_password_expiration).to eq((Time.current + domain.password_expiration_frequency.days).to_date)
    end
  end
end
