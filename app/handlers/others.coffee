define [
  'views/general/modal-confirm-view'
  'features/add_to_library/view'
  'views/trainer/workouts/workout_schedule_modal_view'
  'models/workout_schedule'
  'views/trainer/account-type-modal-view'
  'features/video/upload/view'
  'features/video/upload/model'
], (
  ModalConfirmView
  ModalAddToLibraryView
  WorkoutScheduleView
  WorkoutSchedule
  AccountTypeModalView
  VideoUploadModalView
  VideoModel
) ->

  (App) ->

    App.reqres.setHandler 'data:reload', (category, rootId) ->
      uid = App.request('current_user_id')
      $.ajax
        url: "/users/#{uid}/collections/library/#{rootId}"
        type: 'GET'
        dataType: 'json'
        success: (data) ->
          App.data[category] = data.items

    App.reqres.setHandler 'base:confirmationalModal', (data) ->
      confirmView = new ModalConfirmView data
      region = App.baseView.baseModalRegion
      region.show(confirmView)
      region.$el.modal('show')

      App.listenToOnce confirmView, "modal:closed", ->
        region.$el.modal('hide')
        region.destroy()

    App.reqres.setHandler 'base:addToLibraryModal', (data) ->
      addToLibraryView = new ModalAddToLibraryView data
      region = App.baseView.baseModalRegion
      region.show(addToLibraryView)
      region.$el.modal('show')
      region.$el.one 'hidden.bs.modal', ->
        addToLibraryView.destroy()

    App.reqres.setHandler 'base:workoutSchedule', (data) =>
      view = new WorkoutScheduleView
        model: new WorkoutSchedule

      region = App.baseView.baseModalRegion
      region.show(view)
      region.$el.modal('show')

      App.listenToOnce view, "modal:closed", ->
        region.$el.modal('hide')
        region.destroy()

    App.reqres.setHandler 'base:accountTypes', (data) =>
      view = new AccountTypeModalView

      region = App.baseView.baseModalRegion
      region.show(view)
      region.$el.modal('show')

      App.listenToOnce view, "modal:closed", ->
        region.$el.modal('hide')
        region.destroy()

    App.reqres.setHandler 'base:uploadVideo', ->
      model = new VideoModel
      view = new VideoUploadModalView
        model: model

      region = App.baseView.baseModalRegion
      region.show(view)
      region.$el.modal
        keyboard: false
        background: 'static'

      region.$el.modal 'show'

      App.listenToOnce view, "modal:closed", ->
        region.$el.modal('hide')
        region.destroy()

      view

    App.reqres.setHandler 'ajax:options:create', (params) ->
      options =
        url: params.url
        type: params.type || 'POST'
        contentType: params.contentType || 'application/json'
        data: params.data || {}