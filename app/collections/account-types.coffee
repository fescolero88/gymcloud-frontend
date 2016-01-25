define [
  'models/account-type'
], (
  AccountTypeModel
) ->

  class AccountTypes extends Backbone.Collection

    type: 'AccountTypes'

    model: AccountTypeModel
