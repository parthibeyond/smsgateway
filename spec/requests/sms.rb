# spec/requests/sms_spec.rb
require 'rails_helper'

RSpec.describe "Sms", type: :request do
  before do
    @account = Account.create(username: 'test', auth_id: 'pass')
    @phone_number = @account.phone_number.create(number: '1234567890')
  end

  describe "POST /inbound/sms" do
    context 'invalid params' do
      it "when `from` is empty it returns error message `from is missing`" do
        post '/inbound/sms', params: { from: '', to: '1234567890', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('From is missing')
      end

      it "when `from` is 12345 it returns error message `from is invalid`" do
        post '/inbound/sms', params: { from: '12345', to: '1234567890', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('From is invalid')
      end
      
      it "when `to` is empty it returns error message `to is missing`" do
        post '/inbound/sms', params: { from: '1234567890', to: '', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('To is missing')
      end
      
      it "when `to` is 12345678901234567890 it returns error message `to is invalid` & `to parameter not found`" do
        post '/inbound/sms', params: { from: '1234567890', to: '12345678901234567890', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('To is invalid')
        expect(response.body).to include('To parameter not found')
      end
      
      it "when `text` is empty it returns error message `text is missing`" do
        post '/inbound/sms', params: { from: '1234567890', to: '1234567890', text: '' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Text is missing')
      end
    end
    context 'valid params' do
      it "returns success message for valid request" do
        post '/inbound/sms', params: { from: '123456', to: '1234567890', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('inbound sms ok')
      end
    end
  end

  describe "POST /outbound/sms" do
    context 'invalid params' do
      it "when `from` is empty it returns error message `from is missing`" do
        post '/inbound/sms', params: { from: '', to: '1234567890', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('From is missing')
      end

      it "when `from` is 12345 it returns error message `from is invalid`" do
        post '/inbound/sms', params: { from: '12345', to: '1234567890', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('From is invalid')
      end
      
      it "when `to` is empty it returns error message `to is missing`" do
        post '/inbound/sms', params: { from: '1234567890', to: '', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('To is missing')
      end
      
      it "when `to` is 12345678901234567890 it returns error message `to is invalid`" do
        post '/inbound/sms', params: { from: '1234567890', to: '12345678901234567890', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('To is invalid')
      end
      
      it "when `text` is empty it returns error message `text is missing`" do
        post '/inbound/sms', params: { from: '1234567890', to: '1234567890', text: '' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Text is missing')
      end
    end
    context 'valid params' do
      it "returns success message for valid request" do
        post '/outbound/sms', params: { from: '1234567890', to: '123456', text: 'Hello' }, headers: basic_auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('outbound sms ok')
      end
    end
  end

  private

  def basic_auth_headers
    { 'Authorization' => ActionController::HttpAuthentication::Basic.encode_credentials('test', 'pass') }
  end
end
