# Copy it to config.coffee
config = {api: {}}

production = false
oauthClientId = '3f4e4ee19f38ca1839a29e47c21c9cd541faeaf42760d81ff415b0bb84037306'

config.api.url = if production
  '//alpha.gymcloud.com'
else
  '//alpha.s.gymcloud.com'

module.exports = config
