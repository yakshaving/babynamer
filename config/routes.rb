Babynames::Application.routes.draw do

  root :to => 'babyname#show'

  get "/names/:categories", to: "babyname#getnames"

end
