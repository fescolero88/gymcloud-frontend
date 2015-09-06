define [
  'backbone'
  'models/account-type'
], (
  Backbone
  AccountTypeModel
) ->

  class AccountTypes extends Backbone.Collection

    model: AccountTypeModel