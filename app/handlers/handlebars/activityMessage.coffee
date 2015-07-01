module.exports = (item) ->
  activityMapMessages =
    message_received:
      message: 'Received message from'
      link: ->
        "<a href=#>#{item.sender_full_name}</a>"
    new_item_assigned:
      message: 'Was assigned new'
      link: ->
        "#{item.context.assign_type} <a href=#>#{item.context.assign_name}</a>"
  activityMapMessages[item.type]
