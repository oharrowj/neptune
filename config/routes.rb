Rails.application.routes.draw do

  root 'share#index'

  post  '/share' => 'share#create' 
  get   '/share/:id' => 'share#show' 

  get '*path' => 'error#invalid'

end