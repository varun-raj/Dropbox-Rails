require 'rails_helper'

RSpec.describe DashboardController, :type => :controller do

  describe "#show" do
    let(:dropbox) { nil }

    before do
      allow(controller).to receive_messages(:dropbox => dropbox)
    end

    context "when dropbox is enabled" do

      let(:dropbox) do
        Dropbox::API::Client.new
      end

      it "displays page" do
        get :show
        expect(response).to render_template("show")
      end

    end

    context "when dropbox is disabled" do

      it "redirects to auth page" do
        get :show
        expect(response).to redirect_to(dropbox_path)
      end

    end

  end

end

