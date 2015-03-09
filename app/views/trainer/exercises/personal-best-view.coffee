Marionette = require 'backbone.marionette'
PersonalBestModel = require 'models/trainer/personal-best-model'
PersonalBestCollection = require 'models/trainer/personal-best-collection'
PersonalBestModalView = require 'views/trainer/exercises/personal-best-modal'

class EmptyView extends Marionette.ItemView

  template: Templates.trainer.exercises.personal_best_empty

class PersonalBestItemView extends Marionette.ItemView

  template: Templates.trainer.exercises.personal_best_item

  tagName: 'li'

  className: 'gc-exercises-bests-best'

  model: PersonalBestModel

  ui:
    deleteButton: '.gc-exercises-bests-delete'

  events:
    'click @ui.deleteButton': 'deletePersonalBest'

  modelEvents:
    sync: 'render'

  deletePersonalBest: (ev) =>
    ev.preventDefault()
    App.request 'base:confirmationalModal',
      title: "Delete personal best"
      content: "Are you sure you want to delete this personal best?"
      confirmBtn: "Delete"
      confirmCallBack: =>
        @model.destroy()

class PersonalBestCollectionView extends Marionette.CollectionView

  childView: PersonalBestItemView

  childViewContainer: 'ul'

  emptyView: EmptyView

module.exports = class PersonalBestView extends Marionette.LayoutView

  template: Templates.trainer.exercises.personal_best

  ui:
    showModal: '.gc-add-personal-best'
    modal: '#gc-add-personal-best-modal'

  events:
    'click @ui.showModal': 'showAddPersonalBestModal'

  regions:
    list: '#gc-personal-best-collection'
    modal: '#gc-add-personal-best-modal'

  initialize: (data) =>
    @itemId = data.itemId
    @assign = data.assign
    @key = data.key

  onShow: =>
    @personalBest = new PersonalBestCollection
    @personalBest.url = "#{@personalBest.urlRoot}/#{@itemId}/#{@assign}/#{@key}/records"
    @personalBest.fetch()
    personalBestView = new PersonalBestCollectionView collection: @personalBest
    @list.show personalBestView

  showAddPersonalBestModal: =>
    modal = new PersonalBestModalView
      id: @itemId
      item_id: @key
    @modal.show modal
    @ui.modal.modal 'show'
    @listenTo modal, 'personal_best:added', @personalBestAdded

  personalBestAdded: =>
    @ui.modal.modal 'hide'
    App.request 'messenger:show',
      message: 'New personal best added'
      type: 'info'
    @personalBest.fetch()
