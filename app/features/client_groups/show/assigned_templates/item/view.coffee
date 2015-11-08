define [
  './template'
], (
  template
) ->
  class AssignedTemplateItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    events:
      'click a.gc-exercises-assign-btn-del': '_unassign'

    templateHelpers: =>
      type = @model.type
      url: do =>
        resourceRoot = _.chain(type).underscore().pluralize().value()
        "##{resourceRoot}/#{@model.id}"
      iconClassName: do ->
        templateType = _.chain(type).humanize().words().first()
        templateType.pluralize().value().toLocaleLowerCase()

    _unassign: ->
      @options.clientGroup.unassign(@model).then => @destroy()