View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class ItemView extends View
  autoRender: true
  className: 'row'
  region: 'content'

  listen:
    # 'all': (event) => utils.log "item-view heard #{event}"
    'addedToParent': => utils.log "heard addedToParent"

  initialize: (options) =>
    super
    if @model
      @template = require "views/templates/#{@model.get 'template'}"
    else
      @template = require "views/templates/404"

    @type = options.type
    @sub_type = options.sub_type
    @recent_posts = options.recent_posts
    @recent_projects = options.recent_projects
    @popular_projects = options.popular_projects
    @recent_photos = options.recent_photos
    @popular_photos = options.popular_photos
    @recent = options.recent
    @popular = options.popular
    @title = options.title
    @pager = options.pager
    mediator.setActive options.active

    if @model
      utils.log "initializing #{@model.get 'title'} item-view"
    else
      utils.log "initializing 404 item-view"

    @subscribeEvent 'screenshots:synced', (screenshots) =>
      utils.log 'item-view heard screenshots synced event'
      collection = mediator.portfolio.mergeModels(
        screenshots, ['url_s', 'url_m'], 'main')

      collection = collection.mergeModels(
        screenshots, ['url_sq'], 'thumb')

      @setTemplateData collection, 'portfolio'

    @subscribeEvent 'gallery:synced', (gallery) =>
      utils.log 'item-view heard gallery synced event'
      @setTemplateData gallery

    @subscribeEvent 'portfolio:synced', (portfolio) =>
      utils.log 'item-view heard portfolio synced event'
      @setTemplateData portfolio

  render: =>
    super
    utils.log "rendering item-view"
    console.log @model

  setTemplateData: (collection, type=false) =>
    utils.log 'set item-view template data'
    @["recent_#{@sub_type}s"] = collection.getRecent type
    @["popular_#{@sub_type}s"] = collection.getPopular type
    @getTemplateData()
    @render()

  getTemplateData: =>
    utils.log 'get item-view template data'
    templateData = super
    templateData.page_title = @title
    templateData.pager = @pager
    templateData.recent_posts = @recent_posts
    templateData.recent_projects = @recent_projects
    templateData.popular_projects = @popular_projects
    templateData.recent_photos = @recent_photos
    templateData.popular_photos = @popular_photos
    if @sub_type
      templateData["recent_#{@sub_type}s"] = @recent
      templateData["popular_#{@sub_type}s"] = @popular

    if @model
      templateData.partial = @model.get 'partial'

    templateData

