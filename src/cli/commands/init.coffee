fs = require "fs"
path = require("path")
require "js-yaml"
mkdirp = require("mkdirp").sync
which = require("which").sync
apacheconf = require("../../../../node-apacheconf")
yaml = require("js-yaml")
exec = require('child_process').exec
_ = require "underscore"

exports.run = ->
  console.log "Initializing `hache`..."
  hachePath = path.join(__dirname,"../../../")
  config = {}
  dir = path.join(process.cwd(),'.hache')
  configPath = path.join(dir,'config.yml')
  accessLog = path.join(dir,'logs','access.log')
  errorLog = path.join(dir,'logs','errors.log')
  mkdirp(dir)
  mkdirp(path.join(dir,'logs'))
  mkdirp(path.join(dir,'modules'))
  initConfig = (callback) ->
    #LOCATE AND PARSE EXISTING HTTPD.CONF
    try
      httpdBin = which("httpd")
    catch e
      httpdBin = which("apache2")
    
    console.log httpdBin
    apache = 
      httpd: httpdBin
    # Pull information about current apache setup.
    exec httpdBin + " -V",(err,stdout,stderr) ->
      apacheConfig =  stdout
      console.log stdout
      serverRoot = apacheConfig.match(/HTTPD\_ROOT\="[^"]*"/g)[0].replace(/"/g,'').replace("HTTPD_ROOT=",'')
      configDir = apacheConfig.match(/SERVER\_CONFIG\_FILE\="[^"]*"/g)[0].replace(/"/g,'').replace("SERVER_CONFIG_FILE=","")
      console.log "Server Root: #{serverRoot}"
      console.log "Config Dir #{configDir}"
      apacheConfig = path.resolve(serverRoot,configDir)

      fileData = fs.readFileSync(apacheConfig,{ encoding: "UTF8" });

      vhostTmpl = _.template(fs.readFileSync(path.join(hachePath,"lib/templates/virtualhost.conf"),{encoding: "UTF8"}))
      default_config = path.resolve(__dirname,'../../../default_config.yml')
      defaultConfig = require(default_config)
      defaultConfig.DocumentRoot = process.cwd()
      defaultConfig.ServerRoot = serverRoot
      defaultConfig.AccessLog = path.join(dir,'logs/access')
      defaultConfig.ErrorLog = path.join(dir,'logs/errors')
      vhostConfig = vhostTmpl(defaultConfig)

      fullConfig = fileData + "\n" + vhostConfig
      
      fs.writeFileSync(path.join(dir,"httpd.conf"),fullConfig)
      console.log "Created a new `hache` config in #{path.join(dir,'.hache')}."
      console.log "You may now edit the `.hache` file or type `hache server` to start it up!"
      callback(null,yaml.safeLoad(fs.readFileSync configPath, { encoding: "UTF8" }))

      apacheconf apacheConfig, (err, config, parser) ->
        #console.log err  if err
        #console.log config
        
        Object.keys(cleanConfig).forEach (key) ->
          if cleanConfig[key].length == 1
            cleanConfig[key] = cleanConfig[key][0].replace(/"/g,'')
        
        console.log cleanConfig
        newConfig = _.extend(defaultConfig,cleanConfig)
        newConfig.DocumentRoot = process.cwd()
        newConfig.ServerRoot = serverRoot
        #newConfig.AccessLog = accessLog + " combine"
        newConfig.ErrorLog = errorLog
        
        
        


  initConfig (err, data) ->
    return new Error(err)  if err
    config = data
    
    