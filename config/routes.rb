Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "posts#index"
  resources :posts do
    resources :comments, only: [:create, :update, :destroy]
    member do
      post :collect
      post :uncollect
      get  :edit_current_comment
    end
  end

  resources :users, only: [:show, :edit, :update] do
    member do
      get :comments
      get :collects
      get :drafts
      get :friends
    end    
  end
  
  resources :friendships, only: [:create, :destroy] do
    member do
      post   :accept
      delete :ignore
    end
  end

  resources :feeds, only: :index
  
  namespace :admin do
    resources :categories
    resources :users, only: [:index, :update]
    root "categories#index"
  end  

  namespace :api, defaults: {format: :json} do
    namespace :v1 do

      post "/login" => "auth#login"
      post "/logout" => "auth#logout"

      resources :posts, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
