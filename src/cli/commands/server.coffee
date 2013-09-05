fs = require "fs"
path = require("path")
_ = require "underscore"
config = require("../../config")
httpdBin = config.httpdBin
exports.run = ->
  if _.isEmpty(config.hache) 
    console.error "`hache` config not found in this directory.\nPlease run `hache init` and try again."
  else
    console.log "Starting `hache` server instance..."
  
  console.log 'Running apache at ' + config.hache.ServerName + ' on port ' + config.hache.Listen
  cmd = [
    "sudo #{httpdBin} -k start"
    "-f #{path.join(process.cwd(),'.hache','httpd.conf')}"
    '-e info'
    '-D FOREGROUND'
  ]

  httpd = require('child_process').exec cmd.join(" ")

  httpd.stdout.on 'data', (data) ->
    console.log(data)

  httpd.stderr.on 'data', (data) ->
    console.log(data)

  httpd.on 'close', (code) ->
    console.log('httpd process exited with code ' + code)