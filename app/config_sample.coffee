# Copy it to config.coffee
config = {api: {}}

production = true

config.api.url = if production
  '//gymcloud.com'
else
  '//gymcloud-stagingapp.herokuapp.com'

module.exports = config
