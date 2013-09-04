fs = require "fs"
path = require("path")
require "js-yaml"
mkdirp = require("mkdirp").sync
which = require("which").sync
apacheconf = require("apacheconf")
yaml = require("js-yaml")
exec = require('child_process').exec
_ = require "underscore"

exports.run = ->
  console.log "Initializing `hache`..."
  config = {}
  dir = path.join(process.cwd(),'.hache')

  mkdirp(dir)
  initConfig = (callback) ->
    #LOCATE AND PARSE EXISTING HTTPD.CONF
    httpdBin = which("httpd")

    exec httpdBin + " -V | grep SERVER",(err,stdout,stderr) ->
      apacheConfig =  stdout
      apacheConfig = apacheConfig.match(/"[^"]*"/g)[0].replace(/"/g,'')
      
      console.log "Server Config: #{apacheConfig}"
      
      apacheconf apacheConfig, (err, config, parser) ->
        throw err  if err
        #console.log config
        cleanConfig = _.pick config,
          'ServerRoot',
          'LoadModule',
          'Listen',
          'LogLevel',
          'ErrorLog',
          'DocumentRoot',
          'ServerAdmin'
        Object.keys(cleanConfig).forEach (key) ->
          if cleanConfig[key].length == 1
            cleanConfig[key] = cleanConfig[key][0].replace(/"/g,'')
        
        console.log cleanConfig
        default_config = path.resolve(__dirname,'../../../default_config.yml')
        defaultConfig = require(default_config)
        newConfig = _.extend(defaultConfig,cleanConfig)
        configPath = path.join(dir,'config.yml')
        
        doesExist = fs.existsSync configPath
        unless doesExist
          fs.writeFileSync(configPath,yaml.safeDump(newConfig))
          console.log "Created a new `hache` config in #{path.join(dir,'.hache')}."
          console.log "You may now edit the `.hache` file or type `hache server` to start it up!"
          callback(null,yaml.safeLoad(fs.readFileSync configPath, { encoding: "UTF8" }))
          
        else
          console.log "`hache` config already exists, delete the `.hache` file and re-try to create from default."
          callback(null,yaml.safeLoad(fs.readFileSync configPath, { encoding: "UTF8" }))



  initConfig (err, data) ->
    return new Error(err)  if err
    config = data
    
    