Rails.application.routes.draw do

  get "/" => "hand#top"
  get "result"=>"hand#result"
  get "check" => "hand#check"
  post "check" => "hand#check"





end
