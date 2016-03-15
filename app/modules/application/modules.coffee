define [
  'routers/all'
  'features/current_user/module'
  'features/header/module'
  'features/spinner/module'
  'features/messenger/module'
  'features/sidebar/module'
  'features/search/module'
  'features/modal/confirm/module'
  'features/modal/prompt/module'
  'features/modal/client_groups/module'
  'features/drag_n_drop/module'
  'modules/utils/freshdesk'
], (
  AllRouters
  CurrentUserModule
  HeaderModule
  SpinnerModule
  MessengerModule
  SidebarModule
  SearchModule
  ModalConfirmModule
  ModalPromptModule
  ModalClientGroupModule
  DragNDropModule
  FreshDeskModule
) ->

  (app) ->

    app.module 'AllRouters', AllRouters
    app.module 'CurrentUser', CurrentUserModule
    app.module 'Header', HeaderModule
    app.module 'Sidebar', SidebarModule
    app.module 'Spinner', SpinnerModule
    app.module 'Messenger', MessengerModule
    app.module 'Search', SearchModule
    app.module 'ModalConfirm', ModalConfirmModule
    app.module 'ModalPrompt', ModalPromptModule
    app.module 'ClientGroupModal', ModalClientGroupModule
    app.module 'DragNDrop', DragNDropModule
    if feature.isEnabled('freshdesk_widget')
      app.module 'FreshDesk', FreshDeskModule
