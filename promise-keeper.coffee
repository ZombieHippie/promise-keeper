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
  
  # Log current value with optional title
  log: (title) ->
    @then (value) ->
      def = new Deferred
      # Log
      console.log("<#{title}>") if title?
      console.log value
      # Continue chain with value
      def.resolve value
      def.promise
 
  # Edit current value with function
  edit: (fn) ->
    @then (value) ->
      def = new Deferred
      def.resolve fn value
      def.promise
 
  # Declare time to delay
  delay: (time) ->
    # Return function ((value)->) to .then((value)->)
    @then (value) ->
      def = new Deferred
      setTimeout (->
        def.resolve(value)
      ), time
      # Return the promise to .then(->return promise)
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