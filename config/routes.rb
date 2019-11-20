# typed: strong
Rails.application.routes.draw do
  root 'expenses#index'

  get 'expenses/index'
end
