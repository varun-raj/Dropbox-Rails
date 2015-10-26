Rails.application.routes.draw do

  get "/dropbox",  :controller => "dropbox", :action => "index"
  get "/dropbox/auth",  :controller => "dropbox", :action => "show"
  get "/dropbox/callback",  :controller => "dropbox", :action => "create"

  root 'dashboard#show'
  get "/download" => 'dashboard#download2', as: :download
  get "/folderdownload/:folderpath" => 'dashboard#folder_download', as: :folder_download
end
