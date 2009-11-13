ActionController::Routing::Routes.draw do |map|
  map.root :controller => "home"
  map.resources :posts

  map.namespace(:admin) do |admin|
    admin.root :controller => 'posts'
    admin.resources :posts, :collection => { :search => :get }
  end
  map.open_id_complete 'session', :controller => 'sessions', :action => 'create', :requirements => { :method => :get }
  map.resource  :session
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
end
