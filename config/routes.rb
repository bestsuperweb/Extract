Rails.application.routes.draw do
  get 'static/home'

  get 'static/export',  to: 'static#export', as: 'export'

  root 'static#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
