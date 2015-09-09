define [
  'app/controllers/auth/auth-controller'
], (
  AuthController
) ->

  describe 'AuthController', ->

    context 'instance', ->

      before ->
        @subject = new AuthController

      it '#superclass', ->
        expect(@subject).to.be.an.instanceOf(Marionette.Controller)

      it 'has methods', ->
        expect(@subject).to.respondTo('login')
        expect(@subject).to.respondTo('logout')
        expect(@subject).to.respondTo('forgotPassword')
        expect(@subject).to.respondTo('signUp')
        expect(@subject).to.respondTo('resetPassword')
        expect(@subject).to.respondTo('confirmRegistration')
        expect(@subject).to.respondTo('resendConfirmation')
