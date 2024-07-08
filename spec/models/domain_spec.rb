# spec/models/domain_spec.rb
require 'rails_helper'

RSpec.describe Domain, type: :model do
  context 'associations' do
    it { should have_many(:mailboxes) }
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      domain = Domain.new(name: 'example.com', password_expiration_frequency: 30)
      expect(domain).to be_valid
    end

    it 'is not valid without a name' do
      domain = Domain.new(password_expiration_frequency: 30)
      expect(domain).to_not be_valid
    end

    it 'is not valid without a password_expiration_frequency' do
      domain = Domain.new(name: 'example.com')
      expect(domain).to_not be_valid
    end

    it 'is not valid with a password_expiration_frequency other than 30, 60, 90, or 180' do
      domain = Domain.new(name: 'example.com', password_expiration_frequency: 45)
      expect(domain).to_not be_valid
    end

    it 'is valid with a password_expiration_frequency of 30' do
      domain = Domain.new(name: 'example.com', password_expiration_frequency: 30)
      expect(domain).to be_valid
    end

    it 'is valid with a password_expiration_frequency of 60' do
      domain = Domain.new(name: 'example.com', password_expiration_frequency: 60)
      expect(domain).to be_valid
    end

    it 'is valid with a password_expiration_frequency of 90' do
      domain = Domain.new(name: 'example.com', password_expiration_frequency: 90)
      expect(domain).to be_valid
    end

    it 'is valid with a password_expiration_frequency of 180' do
      domain = Domain.new(name: 'example.com', password_expiration_frequency: 180)
      expect(domain).to be_valid
    end
  end
end
