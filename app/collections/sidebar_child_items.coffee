define ->

  class SidebarChildItems extends Backbone.Collection

    modelId: (attrs) ->
      attrs.key
