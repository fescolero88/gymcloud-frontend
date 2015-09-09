define [
  'app/controllers/trainer/trainer-controller'
], (
  TrainerController
) ->

  describe 'TrainerController', ->

    context 'instance', ->

      before ->
        @subject = sinon.createStubInstance(TrainerController)

      it '#superclass', ->
        expect(@subject).to.be.an.instanceOf(Marionette.Controller)

      it 'has methods', ->
        expect(@subject).to.respondTo('clients')
        expect(@subject).to.respondTo('clientOrGroup')
        expect(@subject).to.respondTo('client')
        expect(@subject).to.respondTo('group')
        expect(@subject).to.respondTo('me')
        expect(@subject).to.respondTo('globalView')
        expect(@subject).to.respondTo('searchInLibrary')
        expect(@subject).to.respondTo('initializeSplashListeners')
