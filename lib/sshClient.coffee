connection = require("ssh2")


exports.test = (locals) ->
  conn = new connection()
  conn.on("ready", ->
    console.log "Connection :: ready"
    conn.exec "mkdir delete_me", (err, stream) ->
      throw err  if err
      stream.on("exit", (code, signal) ->
        console.log "Stream :: exit :: code: " + code + ", signal: " + signal
        return
      ).on("close", ->
        console.log "Stream :: close"
        conn.end()
        return
      ).on("data", (data) ->
        console.log "STDOUT: " + data
        return
      ).stderr.on "data", (data) ->
        console.log "STDERR: " + data
        return

      return

    return
  ).connect
    host: "server_url"
    port: 22
    username: "user_name"
    privateKey: require("fs").readFileSync(locals.root + "/authorized_keys/id_rsa")
