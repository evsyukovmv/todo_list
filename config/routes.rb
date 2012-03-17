TodoList::Application.routes.draw do

  root :to => 'pages#home'

  match '/signup',  :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/profile', :to => 'users#edit'
  match '/access', :to => 'pages#access'
  match '/task_lists/:task_list_id/tasks/:state' => 'tasks#index', state: /(done|in_process|not_done)/
  match '/projects/:id/remove_user/:user_id' => 'projects#remove_user', as: 'remove_user_project'

  resources :sessions, :only => [:new, :create, :destroy]
  resources :users, only: [:new, :create, :edit, :show, :update, :destroy]

  resources :projects do
    resources :task_lists, :only => [:index, :new, :create, :destroy]
    member do
      get 'users'
      get 'invite'
      post 'add_user'
    end
  end

  resources :task_lists do
    resources :tasks do
      member do
        get 'change_state'
      end
    end
  end

end