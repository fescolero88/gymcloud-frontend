module.exports = class ModalAddToLibraryLibraryView extends Marionette.CompositeView

  template: require('templates/general/modal_add_to_library_library')

  templateHelpers: =>
    typeName: @type
    items: => App.request "data:#{@type}"

  events:
    'click .toggle-menu': 'toggleMenu'

  ui:
    toggleMenu: '.toggle-menu'
    allLinks: '.gc-add-modal-list-wrapper a'

  initialize: (data) ->
    @type = data.type

  toggleMenu: (ev) ->
    if $(ev.target).hasClass('toggle-it') or $(ev.currentTarget).hasClass('toggle-it')
      ev.preventDefault()
      $(ev.currentTarget).toggleClass('active')
      if not $(ev.currentTarget).hasClass('selected')
        @ui.allLinks.removeClass 'selected'
        $(ev.currentTarget).addClass('selected')
      else
        @ui.allLinks.removeClass 'selected'
      @trigger 'folder:selected', $(ev.currentTarget).data 'key'
