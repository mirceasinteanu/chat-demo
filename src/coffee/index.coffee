app        = require('express')()
http       = require('http').Server(app)
io         = require('socket.io')(http)
allClients = []
allUsers   = []

app.get '/', (req, res) ->
  res.sendfile 'index.html'
  return

app.get '/style.css', (req, res) ->
  res.sendfile 'style/style.css'
  return

app.get '/socket-client.js', (req, res) ->
  res.sendfile 'socket-client.js'
  return



io.on 'connection', (socket) ->
  @username = ''
  @isRegistered = false
  @currentSID = socket.id
  socket.on 'username', (un) =>
    @username = un

    unless un.length # Username not provided
      io.emit 'user empty'
    else

      if allUsers.indexOf(un) < 0 # Username is valid
        userProfile = {
          uid: Math.random().toString(36).substr(2, 14)
          uname: un
        }
        io.sockets.connected[@currentSID].emit 'login success', userProfile
        io.emit 'info message', 'Welcome to the party, <strong>' + un + '</strong>'

        @isRegistered = true
        allUsers.push userProfile
        allClients.push socket

        io.emit 'userlist updated', allUsers
      else # Username already taken
        io.emit 'user taken'

  socket.on 'chat message', (msg) ->
    io.emit 'chat message', @username, msg
    return

  socket.on 'user typing', (userProfile) ->
    io.emit 'user typing', userProfile

  socket.on 'disconnect', ->
    return unless @isRegistered
    io.emit 'info message', '<strong>' + @username + '</strong>' + ' has left the playground...'
    i = allClients.indexOf(socket)
    allClients.splice i, 1
    allUsers.splice i, 1
    io.emit 'userlist updated', allUsers
    return
  return

http.listen 3000, ->
  console.log 'listening on *:3000'
  return