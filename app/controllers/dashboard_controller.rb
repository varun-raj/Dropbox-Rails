class DashboardController < ApplicationController

  def show
    foldername = params[:folder] || "/"
    @files = dropbox.ls foldername
    # render json: @files.to_json
  end


  def download
    foldername = params[:file]
    $root_path = "/Users/skcripthq/Projects/dropbox-api-rails-example/public"
    contents = dropbox.download foldername
    metadata = dropbox.find foldername
    file_path = metadata['path']
    filename =  "/"  + file.split("/")[-1]
    file_path = file_path.sub(filename, '')
    puts file_path
    if  !File.directory?($root_path + file_path)
      FileUtils::mkdir_p $root_path + file_path
    end
     open($root_path + metadata['path'], 'w') {|f| f.puts contents }
     render text: "success"
  end

end
