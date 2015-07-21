module.exports = (orderName) ->
  if orderName == '' or orderName == null
    orderName = '-'
  else
    orderName