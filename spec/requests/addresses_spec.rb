# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/addresses', type: :request do
  let(:attributes) do
    { name: 'Name', surname: 'Surname', address: 'Address', phone: 'Phone' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Address.create! attributes
      get addresses_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      address = Address.create! attributes
      get address_url(address)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_address_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      address = Address.create! attributes
      get edit_address_url(address)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Address' do
        expect do
          post addresses_url, params: { address: attributes }
        end.to change(Address, :count).by(1)
      end

      it 'redirects to the created address' do
        post addresses_url, params: { address: attributes }
        expect(response).to redirect_to(address_url(Address.last))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { phone: '8(800)555-35-35' }
      end

      it 'updates the requested address' do
        address = Address.create! attributes
        patch address_url(address), params: { address: new_attributes }
        address.reload
      end

      it 'redirects to the address' do
        address = Address.create! attributes
        patch address_url(address), params: { address: new_attributes }
        address.reload
        expect(response).to redirect_to(address_url(address))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested address' do
      address = Address.create! attributes
      expect do
        delete address_url(address)
      end.to change(Address, :count).by(-1)
    end

    it 'redirects to the addresses list' do
      address = Address.create! attributes
      delete address_url(address)
      expect(response).to redirect_to(addresses_url)
    end
  end
end
