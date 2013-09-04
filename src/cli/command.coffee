# External dependencies.
fs = require "fs"
path           = require 'path'
_ = require 'underscore'
{spawn, exec}  = require 'child_process'
{EventEmitter} = require 'events'
optimist           = require('optimist')

commands = {
  "init":{     command: "init", description: "Init current / specified directory with `hache` config." }
  "server":{   command: "server", description: "Starts the `hache` instance." }
}
usage = "Hache\n
Usage: hache [command]\n
\n
Commands:\n"
_.each commands,(command) ->
  usage += " [#{command.command}] #{command.description}\n"
argv = optimist.usage(usage)
      .argv
exists         = fs.exists or path.exists
useWinPathSep  = path.sep is '\\'

exports.run = ->
  if !argv._.length
    optimist.showHelp()
  return require("./commands/init").run()      if argv._[0] is "init"
  return require("./commands/server").run()       if argv._[0] is "server"