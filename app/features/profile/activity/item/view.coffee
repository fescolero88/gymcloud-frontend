define [
  'moment'
  './template'
], (
  moment
  template
) ->
  class ActivityItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    templateHelpers: ->
      timeAgo: do =>
        date = @model.get('created_at')
        moment(date).fromNow()

      message: do =>
        action = @model.get('key').split('.')[1]
        owner = @model.get('owner').user_profile
        who = "#{owner.first_name} #{owner.last_name}"
        what = "#{@model.get('trackable_type')}##{@model.get('trackable_id')}"
        "#{who} #{action} #{what}"
