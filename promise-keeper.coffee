{ Deferred } = require 'promise.coffee'

class PromiseKeeper
  constructor: (value=null) ->
    def = new Deferred
    def.resolve(value)
    @promise = def.promise

  then: ->
    @promise = @promise.then.apply @promise, arguments
    @

  extend: (fns) ->
    for k, v of fns
      if typeof v is 'function'
        @[k] = v
      else
        throw TypeError("extend(Object fns) only accepts an object of functions")
    @

exports.PromiseKeeper = PromiseKeeper