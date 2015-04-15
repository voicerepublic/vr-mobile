@FactoryGirl = new class FactoryGirl
  constructor: ->
    @_factories = {}

  create: (name, attributes = {}) ->
    name = name.toString()
    throw "Factory #{name} doesn't exist!" unless @_factories.hasOwnProperty name

    model = {}
    angular.extend model, @_factories[name], attributes

    for k, v of model
      model[k] = v() if typeof v == 'function'

    model

  createList: (name, count, attributes = {}) ->
    throw "Uncorrect count '#{count}'!" unless typeof count == 'number'
    count = ~~ +count
    @create(name, attributes) for i in [0...count]
      
  define: (name, attributes) ->
    @_factories[name] = attributes

  undefine: (name) ->
    delete @_factories[name]
