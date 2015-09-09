define [
  'models/account-type'
], (
  AccountTypeModel
) ->

  class AccountTypes extends Backbone.Collection

    model: AccountTypeModel
