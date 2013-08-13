module.exports = 
  name: "init"
  description: "Initializes a new Hache environment within the directory."
  options:[]
  usage: "init [name]"
  action: (name) ->
    console.log "Initialized for #{name}..."