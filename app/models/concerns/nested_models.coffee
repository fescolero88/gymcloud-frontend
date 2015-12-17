define ->

  _nestedModelsInit: (data) ->
    @_nestedModels ?= []
    _.chain(data)
      .pairs()
      .each( ([key, klass]) =>
        @_nestedModels.push(key)
        @[key] = new klass
      )
      .value()

  _nestedModelsParse: (data, namespaces) ->
    _.each namespaces, (namespace) =>
      unless _.isUndefined(data[namespace])
        @[namespace].reset(data[namespace], parse: true)
        delete data[namespace]

  _nestedModelsParseAll: (data) ->
    @_nestedModelsParse(data, @_nestedModels)
