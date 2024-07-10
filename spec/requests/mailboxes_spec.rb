# frozen_string_literal: true

require 'rails_helper'

describe 'Mailboxes', type: :request do
  let(:domain) { Domain.create!(name: 'example.com', password_expiration_frequency: 30) }

  context 'GET /domains/:domain_id/mailboxes' do
    context 'when there are mailboxes' do
      let!(:mailbox_one) { Mailbox.create!(domain:, username: 'user_one', password: 'password') }
      let!(:mailbox_two) { Mailbox.create!(domain:, username: 'user_two', password: 'password') }

      it 'returns a success response with the mailboxes' do
        get "/domains/#{domain.id}/mailboxes"

        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(json_response.size).to eq(2)
        expect(json_response.map { |mailbox| mailbox[:username] }).to include(mailbox_one.username, mailbox_two.username)
      end
    end

    context 'when there are no mailboxes' do
      it 'returns a success response with an empty array' do
        get "/domains/#{domain.id}/mailboxes"

        json_response = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json_response).to be_empty
      end
    end
  end

  context 'POST /domains/:domain_id/mailboxes' do
    context 'with valid parameters' do
      let(:params) { { mailbox: { username: 'user', password: 'password' } } }

      it 'creates a new mailbox' do
        expect {
          post "/domains/#{domain.id}/mailboxes", params:
        }.to change(Mailbox, :count).by(1)

        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(201)
        expect(json_response[:username]).to eq('user')
        expect(json_response).not_to have_key(:password)
        expect(json_response[:scheduled_password_expiration]).to eq((Time.current + domain.password_expiration_frequency.days).to_date.to_s)
        expect(Mailbox.last.password).to eq(Digest::SHA512.hexdigest('password'))
      end
    end

    context 'with invalid parameters' do
      let(:params) { { mailbox: { username: nil } } }

      it 'does not create a new mailbox' do
        post("/domains/#{domain.id}/mailboxes", params:)

        expect(response).to have_http_status(422)
      end
    end
  end

  context 'GET /domains/:domain_id/mailboxes/:mailbox_id' do
    context 'when the mailbox exists' do
      let(:mailbox) { Mailbox.create!(domain:, username: 'user', password: 'password') }

      it 'returns the mailbox' do
        get "/domains/#{domain.id}/mailboxes/#{mailbox.id}"

        expect(response).to be_successful
        expect(response.body).to include(mailbox.username)
        expect(response.body).to_not include(mailbox.password)
      end
    end

    context 'when the mailbox does not exist' do
      it 'returns a not found response' do
        get "/domains/#{domain.id}/mailboxes/999"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'PUT /domains/:domain_id/mailboxes/:id' do
    let!(:mailbox) { Mailbox.create(domain_id: domain.id, username: 'user', password: 'password') }

    context 'with valid parameters' do
      let(:params) { { mailbox: { username: 'new-user', password: 'new-password' } } }

      it 'updates the mailbox' do
        put("/domains/#{domain.id}/mailboxes/#{mailbox.id}", params:)

        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
        expect(json_response[:username]).to eq('new-user')
        expect(json_response).not_to have_key(:password)
        expect(json_response[:scheduled_password_expiration]).to eq((Time.current + domain.password_expiration_frequency.days).to_date.to_s)
        expect(mailbox.password).to_not eq(mailbox.reload.password)
        expect(mailbox.reload.password).to eq(Digest::SHA512.hexdigest('new-password'))
      end
    end

    context 'with invalid parameters' do
      let(:params) { { mailbox: { username: nil } } }

      it 'does not update the mailbox' do
        put("/domains/#{domain.id}/mailboxes/#{mailbox.id}", params:)

        expect(response).to have_http_status(422)
      end
    end
  end

  context 'DELETE /domains/:domain_id/mailboxes/:id' do
    let!(:mailbox) { Mailbox.create(domain_id: domain.id, username: 'user', password: 'password') }

    it 'destroys the mailbox' do
      expect do
        delete "/domains/#{domain.id}/mailboxes/#{mailbox.id}"
      end.to change { Mailbox.count }.by(-1)

      expect(response).to have_http_status(204)
    end
  end
end
