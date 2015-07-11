define [
  'app/routers/auth/auth-router'
  'backbone.marionette'
], (
  AuthRouter
  Marionette
) ->

  describe 'AuthRouter', ->

    context 'instance', ->

      before ->
        @subject = sinon.createStubInstance(AuthRouter)

      it '#superclass', ->
        expect(@subject).to.be.an.instanceOf(Marionette.AppRouter)

      it '#appRoutes', ->
        expect(@subject).to.have.property('appRoutes')
