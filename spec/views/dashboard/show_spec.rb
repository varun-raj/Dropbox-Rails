require 'rails_helper'

RSpec.describe "dashboard/show", :type => :view do

  let(:dropbox) do
    double("Dropbox::API::Client")
  end

  let(:contents) do
    []
  end

  before do
    allow(dropbox).to receive_messages(:ls => contents)
  end

  context "when there are no photos" do

    it "displays that there are no photos" do
      allow(view).to receive_messages(:dropbox => dropbox)
      render
      expect(rendered).to include("No photos")
    end

  end

  context "when there are photos" do

    def build_file(url, mime_type = 'image/jpeg')
      url_object = double("Url", :url => url)
      file_object = double("File", {
        :direct_url => url_object,
        :mime_type => mime_type
      })
      file_object
    end

    context "with an image file" do

      let(:contents) do
        [
          build_file('foo.jpg')
        ]
      end

      it "displays that the photos" do
        allow(view).to receive_messages(:dropbox => dropbox)
        render
        expect(rendered).to include(image_tag('foo.jpg'))
      end

    end

  end

end

