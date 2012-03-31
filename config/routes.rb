TodoList::Application.routes.draw do

  resources :wishes

  devise_for :users

  root to: 'pages#home'

  match '/access', to: 'pages#access'
  match '/task_lists/:task_list_id/tasks/:state' => 'tasks#index', state: /(done|in_process|not_done)/

  resources :projects do
    resources :task_lists, only: [:index, :new, :create, :destroy]
    resources :users, controller: :relationships, only: [:index, :new, :create, :destroy]
  end

  resources :task_lists do
    resources :tasks do
      member do
        get 'change_state'
      end
    end
  end

end