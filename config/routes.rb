Rails.application.routes.draw do

  get "/dropbox",  :controller => "dropbox", :action => "index"
  get "/dropbox/auth",  :controller => "dropbox", :action => "auth"
  get "/dropbox/callback",  :controller => "dropbox", :action => "create"

  root 'dropbox#show'
  get '/intergations/dropbox' => 'dropbox#show'
  get "/download" => 'dropbox#download2', as: :download
  get "/folderdownload/:folderpath" => 'dropbox#folder_download', as: :folder_download
end
