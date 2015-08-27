define [
  'backbone.marionette'
  'app/handlers/data'
], (
  Marionette
  dataHandler
) ->

  describe.only 'handlers: data', ->

    before ->
      App = new Marionette.Application
      App.addInitializer ->
        dataHandler(this)
      App.start()
      @subject = App

    it 'can answer on request', ->
      expect(@subject).to.respondTo('request')

    it 'has container data property', ->
      expect(@subject).to.have.property('data')
        .that.is.an('object')
