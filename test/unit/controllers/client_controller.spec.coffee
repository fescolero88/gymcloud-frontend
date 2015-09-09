define [
  'app/controllers/client/clientpage-controller'
], (
  ClientController
) ->

  describe 'ClientController', ->

    context 'instance', ->

      before ->
        @subject = sinon.createStubInstance(ClientController)

      it '#superclass', ->
        expect(@subject).to.be.an.instanceOf(Marionette.Controller)

      it 'has methods', ->
        expect(@subject).to.respondTo('clientPageAssigments')
        expect(@subject).to.respondTo('searchInLibrary')
        expect(@subject).to.respondTo('clientPageCalendarDay')
        expect(@subject).to.respondTo('clientPageCalendarWeek')
        expect(@subject).to.respondTo('clientPageCalendarMonth')
