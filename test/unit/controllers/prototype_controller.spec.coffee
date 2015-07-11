define [
  'app/controllers/prototype/prototype-controller'
], (
  PrototypeController
) ->

  describe 'PrototypeController', ->

    before ->
      @subject = PrototypeController

    it '#superclass', ->
      expect(@subject).to.be.an.instanceOf(Object)

    it 'has methods', ->
      expect(@subject).to.respondTo('ui')
