require 'rails_helper'

RSpec.describe DropboxController, :type => :controller do
  let(:consumer) { double("Consumer") }
  before do
    allow(Dropbox::API::OAuth).to receive_messages({
      :consumer => consumer
    })
  end

  describe "#show" do
    let(:token) { double("Token") }
    let(:authorize_url) { "https://dropbox.com/path" }

    before do
      allow(consumer).to receive_messages({
        :get_request_token => token
      })
      allow(token).to receive_messages({
        :token => 'token',
        :secret => 'secret',
        :authorize_url => authorize_url
      })
    end

    it "redirects to dropbox" do
      get :show
      expect(response).to redirect_to(authorize_url)
    end

  end

  describe "#create" do
    let(:request_token) do
      double("RequestToken", {
        :get_access_token => access_token
      })
    end
    let(:access_token) do
      double("AccessToken", {
        :token => 'token',
        :secret => 'secret'
      })
    end

    before do
      expect(OAuth::RequestToken).to receive(:new).and_return(request_token)
    end

    it "redirects to home" do
      get :create
      expect(response).to redirect_to("/")
    end

  end

end


