# Copy it to config.coffee
config = {api: {}}

production = true
oauthClientId = '3f4e4ee19f38ca1839a29e47c21c9cd541faeaf42760d81ff415b0bb84037306'

config.api.url = if production
  '//gymcloud.com'
else
  '//gymcloud-stagingapp.herokuapp.com'

module.exports = config
