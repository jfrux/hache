path = require "path"
fs = require "fs"
_ = require "underscore"
which = require("which").sync
yaml = require "js-yaml"
hache_dir = path.resolve(__dirname,"../")
httpd_conf_path = path.join hache_dir,"default_httpd.conf"
dir = process.cwd()
configPath = path.join dir,".hache","config.yml"

httpdConf = _.template(fs.readFileSync(httpd_conf_path,{ encoding: "UTF8" }))
userConf = fs.readFileSync configPath,
  encoding: 'UTF8'

userConf = yaml.safeLoad(userConf)
httpd = httpdConf(userConf)

#fs.writeFileSync(path.join(path.dirname(configPath),'httpd.conf'),httpd)

try
  httpdBin = which("httpd")
catch e
  httpdBin = which("apache2")

if fs.existsSync(configPath)
  module.exports = 
    httpd: httpdConf
    hache: userConf
    httpdBin: httpdBin
