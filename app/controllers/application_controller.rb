class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_dropbox

  def authenticate_dropbox
    redirect_to dropbox_path if dropbox.nil?
  end

  def dropbox
    if dropbox_enabled?
      Dropbox::API::Client.new({
        :token => dropbox_token,
        :secret => dropbox_secret
      })
    end
  end
  helper_method :dropbox

  def dropbox_enabled?
    dropbox_token && dropbox_secret
  end

  def dropbox_token
    session[:dropbox_token]
  end

  def dropbox_secret
    session[:dropbox_secret]
  end

end
