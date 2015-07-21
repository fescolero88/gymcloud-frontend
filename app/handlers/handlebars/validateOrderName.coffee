module.exports = (orderName) ->
  if orderName == '' or orderName == null
    '-'
  else
    orderName