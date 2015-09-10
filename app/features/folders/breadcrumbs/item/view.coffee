define [
  './template'
], (
  template
) ->

  class BreadcrumbsItemView extends Marionette.ItemView

    template: template

    tagName: 'span'
