Marionette = require 'backbone.marionette'

class AuthorScopeButtonItemView extends Marionette.ItemView
  
  template: require('templates/general/search/author_scope_button_item')
  tagName: 'label'

  className: 'btn btn-primary'
    
  onRender: ->
    if @model.get('inScope')
      @el.classList.add 'active'


module.exports = class AuthorScopeCollectionView extends Marionette.CollectionView

  childView: AuthorScopeButtonItemView

  className: 'btn-group'

  attributes:
    "data-toggle": "buttons"

  ui:
    searchScopeRadio: 'input[name=searchScope]'
  
  events:
    'change @ui.searchScopeRadio': 'setSearchScope'

  setSearchScope: =>
    q = @model.get('q')
    entityType = @model.get('entity_type')
    searchScope = @$el.find(':checked').val()

    App.vent.trigger 'search:global', q, entityType, searchScope
