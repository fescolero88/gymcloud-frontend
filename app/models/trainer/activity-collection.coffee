Backbone = require 'backbone'

module.exports = class ActivityCollection extends Backbone.Collection
  initialize: ->
    super
    @page = 0
    @perPage = 0
    @prevLength = 0
    @noMore = false

  loadMore: ->
    @page += 1
    @fetch
      remove: false
      data:
        page: @page
        per_page: @perPage
      success: =>
        if @length > @perPage
          @noMore = @prevLength == @length
        else
          @noMore = true
        @prevLength = @length
