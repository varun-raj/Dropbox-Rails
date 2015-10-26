class DashboardController < ApplicationController
  $downloadpath = Array.new

  def show
    foldername = params[:folder] || "/"
    @files = dropbox.ls foldername
    # render json: @files.to_json
    dropbox.upload "RDHex/" + "sdasd.txt", "sdasd"
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
