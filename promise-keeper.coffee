{ Deferred } = require 'promise.coffee'

class PromiseKeeper
  constructor: (value=null) ->
    def = new Deferred
    def.resolve(value)
    @promise = def.promise
    @_data = {}

  then: ->
    @promise = @promise.then.apply @promise, arguments
    @

  set: (name, setValue) ->
    @then (value) =>
      def = new Deferred
      if setValue?
        @_data[name] = setValue
      else
        @_data[name] = value
      def.resolve value
      def.promise
 
  get: (name) ->
    @then (value) =>
      def = new Deferred
      if name?
        def.resolve @_data[name]
      else
        def.resolve @_data[value]
      def.promise

  useAll: (fns) ->
    for k, v of fns
      if typeof v is 'function'
        console.log "Added .#{k}()"
        @[k] = v
      else
        throw TypeError("useAll only accepts an object of functions")
    @

exports.PromiseKeeper = PromiseKeeper