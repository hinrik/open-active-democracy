ActionController::Routing::Routes.draw do |map|
  map.connect '/priorites/flag/:id', :controller=>'priorities', :action=>'flag'
  map.connect '/priorites/abusive/:id', :controller=>'priorities', :action=>'abusive'
  map.connect '/priorites/not_abusive/:id', :controller=>'priorities', :action=>'not_abusive'

  map.connect '/questions/flag/:id', :controller=>'questions', :action=>'flag'
  map.connect '/documents/flag/:id', :controller=>'documents', :action=>'flag'

  map.connect '/admin/all_flagged', :controller=>'admin', :action=>'all_flagged'
  map.connect '/admin/all_deleted', :controller=>'admin', :action=>'all_deleted'
  map.connect '/users/list_suspended', :controller=>'users', :action=>'list_suspended'

  map.resources :partners, :member => {
    :email => :get,    
    :picture => :get,
    :picture_save => :post
  }
  map.resources :users, :has_one => [:password, :profile], :collection => {:endorsements => :get, :order => :post}, :member => {
    :suspend => :put,
    :unsuspend => :put,
    :activities => :get,
    :comments => :get,
    :questions => :get,
    :discussions => :get,
    :capital => :get,
    :impersonate => :put,
    :followers => :get,
    :documents => :get,
    :stratml => :get,
    :ignorers => :get,
    :following => :get,
    :ignoring => :get,
    :follow => :post,
    :unfollow => :post,
    :make_admin => :put,
    :ads => :get,
    :priorities => :get,
    :signups => :get,
    :legislators => :get,
    :legislators_save => :post,
    :endorse => :post,
    :reset_password => :get,
    :resend_activation => :get } do |users|
     users.resources :messages
     users.resources :followings, :collection => { :multiple => :put }
     users.resources :contacts, :controller => :user_contacts, :as => "contacts", :collection => {
       :multiple => :put, 
       :following => :get,
       :members => :get,
       :not_invited => :get,
       :invited => :get
    }
  end
  
  map.resources :settings, :collection => {
    :signups => :get,    
    :picture => :get,
    :picture_save => :post,
    :legislators => :get,
    :legislators_save => :post,
    :branch_change => :get,
    :delete => :get 
  }
  
  map.resources :priorities, 
    :member => { 
      :flag_inappropriate => :put, 
      :bury => :put, 
      :compromised => :put, 
      :successful => :put, 
      :failed => :put, 
      :intheworks => :put, 
      :endorse => :post, 
      :endorsed => :get, 
      :opposed => :get,
      :activities => :get, 
      :endorsers => :get, 
      :opposers => :get, 
      :discussions => :get, 
      :create_short_url => :put,
      :tag => :post, 
      :tag_save => :put, 
      :questions => :get, 
      :opposer_points => :get, :endorser_points => :get, :neutral_points => :get, :everyone_points => :get,
      :top_points => :get, :endorsed_points => :get, :opposed_top_points=> :get, :endorsed_top_points => :get,
      :opposer_documents => :get, :endorser_documents => :get, :neutral_documents => :get, :everyone_documents => :get,      
      :comments => :get, 
      :documents => :get },
    :collection => { 
      :yours => :get, 
      :yours_finished => :get, 
      :yours_top => :get,
      :yours_ads => :get,
      :yours_lowest => :get,      
      :yours_created => :get,
      :network => :get, 
      :consider => :get, 
      :obama => :get, :not_obama => :get, :obama_opposed => :get,      
      :finished => :get, 
      :ads => :get,
      :top => :get, 
      :rising => :get, 
      :falling => :get, 
      :controversial => :get, 
      :random => :get, 
      :newest => :get, 
      :untagged => :get } do |priorities|
      priorities.resources :changes, :member => { :start => :put, :stop => :put, :approve => :put, :flip => :put, :activities => :get } do |changes|
        changes.resources :votes
      end
      priorities.resources :questions
      priorities.resources :documents
      priorities.resources :ads, :collection => {:preview => :post}, :member => {:skip => :post}
    end
  map.resources :activities, :member => { :undelete => :put, :unhide => :get } do |activities|
    activities.resources :followings, :controller => :following_discussions, :as => "followings"
    activities.resources :comments, 
      :collection => { :more => :get }, 
      :member => { :unhide => :get, :flag => :get, :not_abusive => :post, :abusive => :post }
  end 
  map.resources :questions, 
    :member => { :activity => :get, 
        :discussions => :get, 
        :quality => :post, 
        :unquality => :post, 
        :unhide => :get },
    :collection => { :newest => :get, :revised => :get, :your_priorities => :get } do |points|
    points.resources :revisions, :member => {:clean => :get}
  end
  map.resources :documents, 
    :member => { :activity => :get, 
      :discussions => :get, :quality => :post, :unquality => :post, :unhide => :get },
    :collection => { :newest => :get, :revised => :get, :your_priorities => :get } do |documents|
    documents.resources :revisions, :controller => :document_revisions, :as => "revisions", 
      :member => {:clean => :get}
  end
  map.resources :legislators, :member => { :priorities => :get } do |legislators|
    legislators.resources :constituents, :collection => { :priorities => :get }
  end
  map.resources :blurbs, :collection => {:preview => :put}
  map.resources :email_templates, :collection => {:preview => :put}  
  map.resources :color_schemes, :collection => {:preview => :put}  
  map.resources :governments, :member => {:apis => :get}
  map.resources :widgets, :collection => {:priorities => :get, :discussions => :get, :questions => :get, :preview_iframe => :get, :preview => :post}
  map.resources :bulletins, :member => {:add_inline => :post}
  map.resources :branches, :member => {:default => :post} do |branches|
    branches.resources :priorities, :controller => :branch_priorities, :as => "priorities", 
    :collection => { :top => :get, :rising => :get, :falling => :get, :controversial => :get, :random => :get, :newest => :get, :finished => :get}
    branches.resources :users, :controller => :branch_users, :as => "users",
    :collection => { :talkative => :get, :twitterers => :get, :newest => :get, :ambassadors => :get}
  end
  map.resources :searches, :collection => {:questions => :get, :documents => :get}
  map.resources :signups, :endorsements, :passwords, :unsubscribes, :notifications, :pages, :about, :tags
  map.resource :session
  map.resources :delayed_jobs, :member => {:top => :get, :clear => :get}
  
  # The priority is based upon order of creation: first created -> highest priority.s

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  map.resources :priority_processes
  map.resources :process_speech_master_videos
  map.resources :process_speech_videos
  map.resources :process_discussions
  map.resources :process_documents
  map.resources :process_types
  map.resources :process_document_elements
  map.resources :process_documents
  map.resources :process_document_types
  map.resources :process_document_states

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "news", :action=>"activities"

  map.connect '/destroy_picture', :controller=>"settings", :action=>"picture_destroy"

  # restful_authentication routes
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy' 
  map.unsubscribe '/unsubscribe', :controller => 'unsubscribes', :action => 'new'   

  # non restful routes
  map.connect '/velja_kafla/:tag_name', :controller => 'priorities', :action => 'set_tag_filter'
  map.connect '/askrift', :controller=>'users', :action=>'subscriptions'
  map.connect '/umraedur', :controller=>'priorities', :action=>'newest'
  map.connect '/taka_thatt', :controller=>'priorities', :action=>'new'
  map.connect '/senda_spurningu', :controller=>'questions', :action=>'new'
  map.connect '/senda_erindi', :controller=>'documents', :action=>'new'

  map.connect '/bann', :controller=>'users', :action=>'suspended'

  map.connect '/leita', :controller=>'searches', :action=>'index'
  map.connect '/skraning', :controller=>'sessions', :action=>'create'

  map.connect '/skilmalar', :controller=>'home', :action=>'rules'
  map.connect '/um', :controller=>'home', :action=>'about'
  map.connect '/hjalp', :controller=>'home', :action=>'help'
  
  map.connect '/minar_umraedur', :controller => 'priorities', :action => 'set_subfilter', :filter=>"mine"
  map.connect '/minir_umraedu_kaflar', :controller => 'priorities', :action => 'set_subfilter', :filter=>"my_chapters"
  map.connect '/allar_umraedur', :controller => 'priorities', :action => 'set_subfilter', :filter=>"-1"
  map.connect '/svaradar_spurningar', :controller => 'questions', :action => 'set_subfilter', :filter=>"answered"
  map.connect '/osvaradar_spurningar', :controller => 'questions', :action => 'set_subfilter', :filter=>"unanswered"
  
  map.connect '/yours', :controller => 'priorities', :action => 'yours'
  map.connect '/hot', :controller => 'priorities', :action => 'hot'
  map.connect '/cold', :controller => 'priorities', :action => 'cold'
  map.connect '/new', :controller => 'priorities', :action => 'new'        
  map.connect '/controversial', :controller => 'priorities', :action => 'controversial'

  map.connect '/vote/:action/:code', :controller => "vote"
  map.connect '/splash', :controller => 'splash', :action => 'index'
  map.connect '/issues', :controller => "issues"
  map.connect '/issues.:format', :controller => "issues"
  map.connect '/issues/:slug', :controller => "issues", :action => "show"
  map.connect '/issues/:slug.:format', :controller => "issues", :action => "show"  
  map.connect '/issues/:slug/:action', :controller => "issues"
  map.connect '/issues/:slug/:action.:format', :controller => "issues"  

  map.connect '/portal', :controller => 'portal', :action => 'index'
  map.connect '/set_email', :controller=>'users', :action=>'set_email'
  map.connect '/disable_facebook', :controller=>'users', :action=>'disable_facebook'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect '/pictures/:short_name/:action/:id', :controller => "pictures"
  map.connect ':controller'
  map.connect ':controller/:action'  
  map.connect ':controller/:action.:format' # this one is not needed for rails 2.3.2, and must be removed
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
