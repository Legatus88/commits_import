Rails.application.routes.draw do
  namespace 'api' do
    resources :commits
    post 'commits/import'
  end
end
