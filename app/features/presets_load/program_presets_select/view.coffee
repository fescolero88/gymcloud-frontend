define [
  './template'
  './list/view'
], (
  template
  ProgramPresetListView
) ->

  class ProgramPresetModalView extends Marionette.LayoutView

    template: template

    behaviors:

      regioned:
        views: [
            region: 'presets'
            klass: ProgramPresetListView
        ]

    events:
      'click a.next': '_loadPresets'
      'click a.prev': '_goBack'

    _loadPresets:  ->
      models = @views.presets.collection.where(is_selected: true)

      promises = _.map models, (model) =>
        promise = model.import()
        promise.then(@_parseNewPrograms)
        promise

      $.when(promises...).then => @trigger('changeView', 'next')

    _parseNewPrograms: (response) ->
      user = App.request('current_user')
      programs = user.program_templates
      models = programs.add(response, parse: true)

      _.each models, (model) ->
        folderId = model.get('folder_id')
        folder = user.folders.get(folderId)
        folder.items.add(model)

    _goBack: ->
      @trigger('changeView', 'prev')
