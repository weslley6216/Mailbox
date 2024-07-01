require 'rails_helper'

describe 'Mailboxes', type: :request do
  let(:domain) { Domain.create!(name: "example.com", password_expiration_frequency: 30) }

  context 'GET /domains/:domain_id/mailboxes' do
    it 'returns a success response' do
      get "/domains/#{domain.id}/mailboxes"

      expect(response).to be_successful
    end
  end

  context 'POST /domains/:domain_id/mailboxes' do
    context 'with valid parameters' do
      let(:params) { { mailbox: { username: 'user', password: 'password' } } }

      it 'creates a new mailbox' do
        post "/domains/#{domain.id}/mailboxes", params: params

        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid parameters' do
      let(:params) { { mailbox: { username: nil } } }
      
      it 'does not create a new mailbox' do
        post "/domains/#{domain.id}/mailboxes", params: params

        expect(response).to have_http_status(422)
      end
    end
  end

  context 'GET /domains/:domain_id/mailboxes/:mailbox_id' do
    context 'when the mailbox exists' do
      let(:mailbox) { Mailbox.create!(domain: domain, username: 'user', password: 'password') }

      it 'returns the mailbox' do
        get "/domains/#{domain.id}/mailboxes/#{mailbox.id}"

        expect(response).to be_successful
        expect(response.body).to include(mailbox.username)
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
    let(:mailbox) { Mailbox.create(domain_id: domain.id, username: 'user', password: 'password') }

    context 'with valid parameters' do
      let(:params) { { mailbox: { password: 'newpassword' } } }

      it 'updates the mailbox' do
        put "/domains/#{domain.id}/mailboxes/#{mailbox.id}", params: params

        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid parameters' do
      let(:params) { { mailbox: { username: nil } } }

      it 'does not update the mailbox' do
        put "/domains/#{domain.id}/mailboxes/#{mailbox.id}", params: params

        expect(response).to have_http_status(422)
      end
    end
  end

  context 'DELETE /domains/:domain_id/mailboxes/:id' do
    let(:mailbox) { Mailbox.create(domain_id: domain.id, username: 'user', password: 'password') }

    it 'destroys the mailbox' do
      delete "/domains/#{domain.id}/mailboxes/#{mailbox.id}"

      expect(response).to have_http_status(204)
    end
  end
end
