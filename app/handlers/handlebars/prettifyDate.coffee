moment = require('moment')

module.exports = (timestamp) ->
  moment(new Date(timestamp)).fromNow()
