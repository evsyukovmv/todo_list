TodoList::Application.routes.draw do

  match '/signup',  :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/access', :to => 'pages#access'

  match '/task_lists/:task_list_id/tasks/:state' => 'tasks#index', state: /(done|inprocess|notdone)/
  match '/task_lists/:task_list_id/tasks/:state' => 'tasks#index', state: /(done|inprocess|notdone)/

  match '/projects/:project_id/rempeople/:id' => 'projects#rempeople'

  resources :sessions, :only => [:new, :create, :destroy]

  resources :projects do
    resources :task_lists, :only => [:index, :new, :create, :destroy]
    member do
      get 'peoples'
      get 'invite'
      post 'invite'
    end
  end

  resources :task_lists do
    resources :tasks do
      member do
        get 'change_state'
      end
    end
  end

  resources :users
  match '/profile', :to => 'users#edit'
  root :to => 'pages#home'

end