define ->

  class ProgramPresetModel extends Backbone.Model

    type: 'ProgramPreset'

    defaults:
      id: undefined
      name: ''
      is_selected: false

    import: ->
      options = App.request 'ajax:options:create', url: "#{@url()}/import"
      (@sync || Backbone.sync).call(@, null, @, options)