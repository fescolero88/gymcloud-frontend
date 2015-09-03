define [
  'backbone'
], (
  Backbone
) ->

  class AccountTypeModel extends Backbone.Model

    defaults:
      image: undefined
      title: undefined
      assigned: undefined
      selected: false