module.exports = 
  name: "server"
  description: "Starts an Apache server with the current Hache configuration."
  options: [
    "-p","--port [port]", "Which port to use for Apache"
  ]
  usage: "server [options]"
  action: (options) ->
    