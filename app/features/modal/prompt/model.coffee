define ->

  class PromptModel extends Backbone.Model

    type: 'PromptModel'

    defalts:
      title: 'Title'
      confirmBtn: 'Confirm'
      prompt: ''

    validation:
      prompt:
        required: true
        msg: 'Required field'
