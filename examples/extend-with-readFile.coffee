# Promises

{ PromiseKeeper } = require '../promise-keeper.coffee'
{ Deferred } = require 'promise.coffee'

fs = require 'fs'

nodeStyleLift = (nodefn) ->
  ->
    def = new Deferred
    args = [].slice.call arguments
    args.push (err, res) ->
        if err? then def.reject(err) else def.resolve(res)
    # .then(thenfn)
    thenfn = ->
      nodefn.apply this, args
      return def.promise

    # Check if we are being used inside of a promise api
    if typeof @then is 'function'
      return @then thenfn
    else
      return thenfn

readFileAsync = nodeStyleLift fs.readFile

pk = new PromiseKeeper()
pk
.useAll { readAsync: readFileAsync }
.readAsync('package.json', 'utf8')
.set 'package.json'
.readAsync('promise-keeper.coffee', 'utf8')
.set 'promise-keeper.coffee'
.get 'package.json'
.log("Package Json")
.get 'promise-keeper.coffee'
.log("Promise Keeper")
.then(
  (file) ->
    console.log file
  , (err) ->
    console.error err
)