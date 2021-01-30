Rails.application.routes.draw do
  get 'say/hi' => 'say#hi'
  get 'say/hi_with_name' => 'say#hi_with_name'
  get 'say/hi_names' => 'say#hi_names'

  resources :books do
    collection do
      get :no_sql_executed
      get :sql_executed_in_erb
      get :sql_executed_in_action
    end
  end
end
