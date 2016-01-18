define [
  'routers/all'
  'features/current_user/module'
  'features/header/module'
  'features/spinner/module'
  'features/messenger/module'
  'features/sidebar/module'
  'features/sortables/module'
  'features/search/module'
  'features/modal/confirm/module'
  'features/modal/client_groups/module'
], (
  AllRouters
  CurrentUserModule
  HeaderModule
  SpinnerModule
  MessengerModule
  SidebarModule
  SortableModule
  SearchModule
  ModalConfirmModule
  ModalClientGroupModule
) ->

  (app) ->

    app.module 'AllRouters', AllRouters
    app.module 'CurrentUser', CurrentUserModule
    app.module 'Header', HeaderModule
    app.module 'Sidebar', SidebarModule
    app.module 'Spinner', SpinnerModule
    app.module 'Messenger', MessengerModule
    app.module 'Sortable', SortableModule
    app.module 'Search', SearchModule
    app.module 'ModalConfirm', ModalConfirmModule
    app.module 'ClientGroupModal', ModalClientGroupModule
