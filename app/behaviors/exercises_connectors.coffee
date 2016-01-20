define ->

  class ExercisesConnectorsBehavior extends Marionette.Behavior

    key: 'exercises_connectors'

    colorDefault: '#ababab'

    colors: [
      '#4caf50'
      '#e91e63'
      '#673ab7'
      '#ff9800'
      '#2196f3'
      '#ffeb3b'
      '#00bcd4'
      '#f44336'
      '#009688'
      '#8bc34a'
      '#cddc39'
      '#03a9f4'
      '#ffc107'
      '#3f51b5'
      '#ff5722'
      '#795548'
      '#9c27b0'
      '#607d8b'
    ]

    initialize: ->
      @listenTo(@view, 'show', @_init)
      @listenTo(@view.collection, 'add remove change', @_init)

    _init: ->
      collection = @view.collection

      letterColors = {}
      lastColor = -1

      collection.each (model, index) =>
        previous =
          collection.models[index - 1]?.get('order_letter')
        next =
          collection.models[index + 1]?.get('order_letter')
        current = model.get('order_letter')

        unless letterColors[current]
          lastColor = (lastColor + 1) % @colors.length
          letterColors[current] = @colors[lastColor]
        model.set
          color: letterColors[current]

        position =
          if current is '~'
            ''
          else if current is previous
            if current is next
              'middle'
            else
              'last'
          else if current is next
            'first'
          else
            ''

        model.set
          order_position: position
