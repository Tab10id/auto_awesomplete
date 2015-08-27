Rails.application.routes.draw do
  get 'auto_awesompletes/(:class_name)', to: 'auto_awesompletes#search', as: 'auto_awesompletes'
end