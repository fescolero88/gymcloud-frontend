define [
  'app/controllers/general/search-controller'
  'backbone.marionette'
], (
  SearchController
  Marionette
) ->

  describe 'SearchController', ->

    context 'instance', ->

      before ->
        @subject = sinon.createStubInstance(SearchController)

      it '#superclass', ->
        expect(@subject).to.be.an.instanceOf(Marionette.Controller)

      it 'has methods', ->
        expect(@subject).to.respondTo('search')
