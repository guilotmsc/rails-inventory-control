Rails.application.routes.draw do
  root 'movements#index'

  get 'movements/index'
  post 'movements/csv_file_import'
end
