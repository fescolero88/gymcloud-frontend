define [
  'backbone-nested'
], ->

  class PageModel extends Backbone.NestedModel

    defaults:
      state:
        subpage: 'default'
      data:
        model: undefined
        collection: undefined
