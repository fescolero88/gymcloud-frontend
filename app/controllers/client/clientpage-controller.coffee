Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientPageView = require 'views/client/clientpage-view'
ClientPageSidebarView = require 'views/client/clientpage-sidebar-view'
ClientPageNavView = require 'views/client/clientpage-nav-view'

ClientEWPView = require 'views/client/clientpage-ewp-view'

CalendarDayView = require 'views/client/clientpage-calendar-day-view'
CalendarWeekView = require 'views/client/clientpage-calendar-week-view'
CalendarMonthView = require 'views/client/clientpage-calendar-month-view'

MessagesView = require 'views/general/messages/messages-view'

module.exports = class ClientPageController extends Marionette.Controller
  ewpMethod: false

  initialize: (options) =>
    @mainView = options.mainView
    @userPageView = null
    App.vent.on 'assignments:loaded', =>
      if @ewpMethod
        @[@ewpMethod](@dataType, @ewpKey)
        @ewpMethod = false

  beforeAction: =>
    if not @userPageView or !@userPageView.content
      @userPageView = new ClientPageView()
      @mainView.content.show @userPageView

      @navView = new ClientPageNavView()
      @userPageView.nav.show @navView

  clientPageAssigments: (dataType, key) =>
    @beforeAction()
    @dataType = dataType || 'exercises'
    @key = key
    App.vent.trigger 'clientpage:nav-click', "#gc-clientpage-nav-tab-#{@dataType}"

    items = App.request("data:#{@dataType}")
    if items?
      breadcrumbs = [{title:"#{@dataType}"}]
      if @key
        searchResults = @searchInLibrary(new Backbone.Collection(items), @key, breadcrumbs)
        childModel = searchResults.model
        items = childModel.get('items')
      else
        childModel = new Backbone.Model
      if childModel.get('isFolder') or not @key
        exercisesGlobalView = new ClientEWPView(collection: new Backbone.Collection(items), dataType: @dataType)
        @userPageView.content.show exercisesGlobalView
    else
      @ewpMethod = 'clientPageAssigments'

  searchInLibrary: (items, key, breadcrumbs) =>
    filtered = items.where({key: parseInt(key)})
    if filtered.length
      result = filtered[0]
      breadcrumbs.push({title: result.get('title')})
    else
      items.each (item) =>
        if item.has('items')
          searchResults = @searchInLibrary(new Backbone.Collection(item.get('items')), key, [{title: item.get 'title'}])
          if searchResults.model
            result = searchResults.model
            breadcrumbs = breadcrumbs.concat searchResults.path
    return {model: result, path: breadcrumbs}

  clientPageCalendarDay: (id) =>
    @beforeAction()

    contentView = new CalendarDayView()
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

  clientPageCalendarWeek: (id) =>
    @beforeAction()

    contentView = new CalendarWeekView()
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

  clientPageCalendarMonth: (id) =>
    @beforeAction()

    contentView = new CalendarMonthView()
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'
