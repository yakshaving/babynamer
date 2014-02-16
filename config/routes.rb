Babynames::Application.routes.draw do

  root :to => 'babyname#show'

  get "/names", to: "babyname#getnames"

end
