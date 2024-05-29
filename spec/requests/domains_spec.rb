require 'rails_helper'

describe 'Domains', type: :request do
  context 'GET /domains' do
    it 'returns a success response' do
      get '/domains'

      expect(response).to be_successful
    end
  end

  context 'POST /domains' do
    context 'with valid parameters' do
      let(:params) { { domain: { domain_name: 'example.com', password_expiration_frequency: 30 } } }

      it 'creates a new domain' do
        post '/domains', params: params

        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid parameters' do
      let(:params) { { domain: { domain_name: nil } } }

      it 'does not create a new domain' do
        post '/domains', params: params

        expect(response).to have_http_status(422)
      end
    end
  end

  context 'GET /domains/:id' do
    context 'when the domain exists' do
      let(:domain) { Domain.create(domain_name: 'example.com', password_expiration_frequency: 30) }

      it 'returns the domain' do
        get "/domains/#{domain.id}"

        expect(response).to be_successful
        expect(response.body).to include(domain.domain_name)
        expect(response.body).to include(domain.password_expiration_frequency.to_s)
      end
    end

    context 'when the domain does not exist' do
      it 'returns a not found response' do
        get '/domains/9999'

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'PUT /domains/:id' do
    let(:domain) { Domain.create(domain_name: 'example.com', password_expiration_frequency: 30) }

    context 'with valid parameters' do
      it 'updates the domain' do
        put "/domains/#{domain.id}", params: { domain: { password_expiration_frequency: 60 } }
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the domain' do
        put "/domains/#{domain.id}", params: { domain: { domain_name: nil } }

        expect(response).to have_http_status(422)
      end
    end
  end

  context 'DELETE /domains/:id' do
    let(:domain) { Domain.create(domain_name: "example.com", password_expiration_frequency: 30) }

    it 'destroys the domain' do
      delete "/domains/#{domain.id}"
      
      expect(response).to have_http_status(204)
    end
  end
end
