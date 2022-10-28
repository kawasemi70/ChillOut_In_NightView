Rails.application.routes.draw do

  # namespace :admin do
  #   get 'tags/index'
  # end
  # namespace :admin do
  #   get 'customers/index'
  #   get 'customers/show'
  # end
  # namespace :admin do
  #   get 'posts/index'
  #   get 'posts/show'
  # end
  # get 'tags/index'
   #会員様
 scope module: 'public' do
    devise_for :customers,skip: [:passwords], controllers: {
      registrations: "public/registrations",
      sessions: 'public/sessions'
    }
    root to: "homes#top"
    get "about" => "homes#about"

    #検索ボタンが押された時、Searchesコントローラーのsearchアクションが実行されるように定義。
    #パス名は__「search_path」__
    get 'search' => 'searches#search'

    resources :spots, only: [:index]
    resources :customers, only: [:index, :show, :edit, :update] do
      get 'favorites' => 'customers#favorites'


    end
    resources :posts do
      resource :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    # resources :tags do
    #   get 'posts', to: 'posts#tag_search'
    # end


 end



 #ゲストログイン
 devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in'
 end


  #管理者用

   devise_for :admin, skip: [:registrations, :passwords], controllers: {
      sessions: 'admin/sessions'
    }

  namespace :admin do
    get "/" => "homes#top"

    resources :customers, only: [:index, :show, :destroy]
    resources :posts, only: [:index, :show, :destroy]
    resources :tags, only: [:index, :destroy]

  end




end