class DropboxController < ApplicationController

  skip_before_filter :authenticate_dropbox
  $downloadpath = Array.new

  def index
  end

  def auth
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

  def show
    @foldername = params[:folder] || "/"
    @files = dropbox.ls @foldername
  end


def download2
    foldername = params[:file]
    file_path =  foldername[1..-1]
    $root_path = "/Users/skcripthq/Projects/dropbox-api-rails-example/public"
  #   puts foldername
    metadata = dropbox.find foldername
    contents = dropbox.download file_path
    puts contents
  # contents=   contents.to_s.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
    file_path = metadata['path']
    filename =  "/"  + file_path.split("/")[-1]
    file_path = file_path.sub(filename, '')
    puts file_path
    if  !File.directory?($root_path + file_path)
      FileUtils::mkdir_p $root_path + file_path
    end
     File.open($root_path + foldername, 'wb') {|f| f.puts contents }
     render json: metadata.to_json
  #
  end


  def download(foldername)
    file_path =  foldername[1..-1]
    $root_path = "/Users/skcripthq/Projects/dropbox-api-rails-example/public"
    metadata = dropbox.find foldername
    contents = dropbox.download file_path
    file_path = metadata['path']
    filename =  "/"  + file_path.split("/")[-1]
    file_path = file_path.sub(filename, '')
    if  !File.directory?($root_path + file_path)
      FileUtils::mkdir_p $root_path + file_path
    end
     File.open($root_path + foldername, 'wb') {|f| f.puts contents }

  end

  def folder_traverse(folderpath)
    folder_structure =  dropbox.ls folderpath
    folder_structure.each do |folder|
      if !folder['is_dir']
          $downloadpath.push(folder['path'])
      else
        folder_traverse(folder['path'])
      end

    end
    return 0
  end

  def folder_download
    folderpath = params[:folderpath]
    folder_structure =  dropbox.ls folderpath
        folder_traverse(folderpath)
    folder_structure.each do |folder|
      if folder['is_dir']
          folder_traverse(folder['path'])
      end
    end
    $downloadpath.each do |file|
      download(file)
    end
    render json: $downloadpath.to_json
  end

end

