var allClients, allUsers, app, http, io;

app = require('express')();

http = require('http').Server(app);

io = require('socket.io')(http);

allClients = [];

allUsers = [];

app.get('/', function(req, res) {
  res.sendfile('index.html');
});

app.get('/style.css', function(req, res) {
  res.sendfile('style/style.css');
});

app.get('/socket-client.js', function(req, res) {
  res.sendfile('socket-client.js');
});

io.on('connection', function(socket) {
  this.username = '';
  this.isRegistered = false;
  this.currentSID = socket.id;
  socket.on('username', (function(_this) {
    return function(un) {
      var userProfile;
      _this.username = un;
      if (!un.length) {
        return io.emit('user empty');
      } else {
        if (allUsers.indexOf(un) < 0) {
          userProfile = {
            uid: Math.random().toString(36).substr(2, 14),
            uname: un
          };
          io.sockets.connected[_this.currentSID].emit('login success', userProfile);
          io.emit('info message', 'Welcome to the party, <strong>' + un + '</strong>');
          _this.isRegistered = true;
          allUsers.push(userProfile);
          allClients.push(socket);
          return io.emit('userlist updated', allUsers);
        } else {
          return io.emit('user taken');
        }
      }
    };
  })(this));
  socket.on('chat message', function(msg) {
    io.emit('chat message', this.username, msg);
  });
  socket.on('user typing', function(userProfile) {
    return io.emit('user typing', userProfile);
  });
  socket.on('disconnect', function() {
    var i;
    if (!this.isRegistered) {
      return;
    }
    io.emit('info message', '<strong>' + this.username + '</strong>' + ' has left the playground...');
    i = allClients.indexOf(socket);
    allClients.splice(i, 1);
    allUsers.splice(i, 1);
    io.emit('userlist updated', allUsers);
  });
});

http.listen(3000, function() {
  console.log('listening on *:3000');
});
