define [
  'backbone-nested'
], ->

  class PageModel extends Backbone.NestedModel

    defaults:
      state: 'default'
      data:
        model: undefined
        collection: undefined
