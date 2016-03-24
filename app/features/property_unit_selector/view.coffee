define [
  './list/view'
  './template'
], (
  TooltipView
  template
) ->

  class PropertyUnitSelectorView extends Marionette.LayoutView

    template: template

    className: 'gc-gear-wrapper'

    behaviors:

      regioned:
        views: [
            region: 'tooltip'
            klass: TooltipView
            options: ->
              collection: @collection
        ]

    events:
      'click i.fa.fa-cog': '_showTooltip'

    initialize: ->
      $(document).on "click.#{@cid} mousedown.#{@cid} tap.#{@cid}", (e) =>
        @_hideTooltip() if !@$el.is(e.target) and @$el.has(e.target).length is 0

    onDestroy: ->
      $(document).off(".#{@cid}")

    onShow: ->
      @listenTo @views.tooltip, 'property_unit:selected', @_propertyUnitSelected

    _propertyUnitSelected: (model) ->
      @trigger('property_unit:selected', model)

    _showTooltip: ->
      @views.tooltip.show()

    _hideTooltip: ->
      @views.tooltip.hide()
