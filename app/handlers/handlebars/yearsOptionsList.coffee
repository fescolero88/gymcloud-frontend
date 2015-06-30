Handlebars = require('handlebars')

module.exports = ->
  fromYear = new Date().getFullYear()
  years = ''
  for year in [fromYear..fromYear-80]
    years += "<option value=\"#{year}\">#{year}</option>"
  new Handlebars.SafeString years
