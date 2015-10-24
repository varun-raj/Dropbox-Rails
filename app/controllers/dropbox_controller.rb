class DropboxController < ApplicationController

  skip_before_filter :authenticate_dropbox

  def index
  end

  def show
    consumer      = Dropbox::API::OAuth.consumer(:authorize)
    request_token = consumer.get_request_token
    session[:dropbox_oauth_request_token]  = request_token.token
    session[:dropbox_oauth_request_secret] = request_token.secret
    url = request_token.authorize_url(:oauth_callback => dropbox_callback_url)
    redirect_to url
  end

  def create
    consumer      = Dropbox::API::OAuth.consumer(:authorize)
    request_token = OAuth::RequestToken.new(consumer, session[:dropbox_oauth_request_token], session[:dropbox_oauth_request_secret])
    begin
      access_token = request_token.get_access_token
      session[:dropbox_token] = access_token.token
      session[:dropbox_secret] = access_token.secret
      session[:dropbox_uid] = params[:uid]
      flash[:notice] = 'Successfully connected to Dropbox!'
    rescue OAuth::Unauthorized => e
      flash[:error] = "Couldn't authorize with Dropbox (#{e.message})"
    end
    redirect_to "/"
  end

end

