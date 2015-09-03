define [
  'backbone.marionette'
  'templates/trainer/account-type-modal'
  'views/trainer/account-type-list-view'
  'collections/account-types'
], (
  Marionette
  template
  AccountTypeListView
  AccountTypes
) ->

  class AccountTypeModalView extends Marionette.LayoutView

    template: template

    regions:
      accountTypeRegion: 'region.account-type-list-region'

    ui:
      changeType: '.gc-change-account-type'

    initialize: ->
      @collection = new AccountTypes [
        image: 'app/images/personal-trainer.png'
        title: 'Personal Trainer'
        assigned: true
      ,
        image: 'app/images/strength-conditioning.png'
        title: 'Strength and Conditional Coach'
        assigned: false
      ,
        image: 'app/images/athletic-trainer.png'
        title: 'Athlethic Coach'
        assigned: false
      ,
        image: 'app/images/physical-therapy.png'
        title: 'Physical Therapist'
        assigned: false
      ]

    events:
      'click @ui.changeType': 'accountTypeChanged'

    onRender: ->
      accountTypeListView = new AccountTypeListView collection: @collection
      @getRegion('accountTypeRegion').show accountTypeListView

    accountTypeChanged: ->
      App.request 'messenger:show',
        message: "Account type successfully changed."
        type: 'success'