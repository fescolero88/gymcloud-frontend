define [
  './template'
  '../add_card/view'
], (
  template
  AddCardView
) ->

  class PaymentMethodsView extends Marionette.LayoutView

    template: template

    className: 'payment-methods'

    behaviors: ->

      stickit:
        bindings:
          '.add-card':
            observe: 'add_card'
            visible: true

      regioned:
        views: [
            region: 'add_card'
            klass: AddCardView
        ]

    events:
      'click .title .btn': '_showAddCard'

    initialize: ->
      @model = new Backbone.Model(add_card: false)

    onShow: ->
      @listenTo(@views.add_card, 'card:added', => @model.set(add_card: false))

    _showAddCard: ->
      @model.set(add_card: true)