Rails.application.routes.draw do
  resources :domains do
    resources :mailboxes
  end
end
