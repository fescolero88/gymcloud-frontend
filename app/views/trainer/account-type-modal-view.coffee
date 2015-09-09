define [
  'templates/trainer/account-type-modal'
  'views/trainer/account-type-list-view'
  'collections/account-types'
], (
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
        id: 1
        image: 'gc-acc-personal-trainer'
        title: 'Personal Trainer'
        assigned: true
      ,
        id: 2
        image: 'gc-acc-str-conditioning'
        title: 'Strength and Conditional Coach'
        assigned: false
      ,
        id: 3
        image: 'gc-acc-athletic-trainer'
        title: 'Athlethic Coach'
        assigned: false
      ,
        id: 4
        image: 'gc-acc-physical-therapist'
        title: 'Physical Therapist'
        assigned: false
      ]

    events:
      'click @ui.changeType': 'changeAccountType'

    onRender: ->
      view = new AccountTypeListView collection: @collection
      @getRegion('accountTypeRegion').show view

    changeAccountType: =>
      assigned = @collection.findWhere 'assigned': true
      selected = @collection.findWhere 'selected': true
      if assigned isnt selected
        assigned.set 'assigned', false
        selected.set 'assigned', true
        @accountTypeChanged()

    accountTypeChanged: ->
      App.request 'messenger:show',
        message: "Account type successfully changed."
        type: 'success'
