utils = require 'lib/utils'

module.exports = (match) ->
  utils.log 'start router'
  match '', 'site#index'
  match ':type', 'site#index'
  match ':type/page', 'site#index'
  match ':type/page/:num', 'site#index'
  match ':type/items/tagged/:tag', 'site#index'
  match ':type/items/tagged/:tag/page', 'site#index'
  match ':type/items/tagged/:tag/page/:num', 'site#index'
  match ':type/item', 'site#show'
  match ':type/item/:id', 'site#show'
  match ':type/archives', 'site#archives'
  match ':type/:year/:month/:day/:id', 'site#show'
