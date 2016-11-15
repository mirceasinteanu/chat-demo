var onLoginSuccess, onUserEmpty, onUserTaken, onUserTyping, renderUserList, socket, userProfile;

socket = io();

userProfile = {
  uid: '',
  uname: '',
  sid: ''
};

$('#m').on('keyup', function() {
  if ($(this).val().length) {
    return socket.emit('user typing', userProfile);
  }
});

$('form#un-form').submit(function() {
  socket.emit('username', $('#un').val());
  $('#un').val('');
  return false;
});

$('form#im-form').submit(function() {
  socket.emit('chat message', $('#m').val());
  $('#m').val('');
  return false;
});

socket.on('chat message', function(username, msg) {
  $('#messages').append($('<li>').html('<strong>' + username + ':</strong> ' + msg));
});

socket.on('info message', function(msg) {
  $("#messages").append($('<li class="infotext">').html(msg));
});

onUserTaken = function() {
  return console.log('username taken');
};

onUserEmpty = function() {
  return console.log('username is empty');
};

onLoginSuccess = function(user) {
  userProfile = user;
  return $('form#un-form').fadeOut();
};

renderUserList = function(userList) {
  var i, j, ref, results;
  $('#user-list').empty();
  results = [];
  for (i = j = 0, ref = userList.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
    if (userList[i].uname) {
      results.push($('#user-list').append($('<li>').html('<strong>' + userList[i].uname + '</strong>')));
    } else {
      results.push(void 0);
    }
  }
  return results;
};

onUserTyping = function(user) {
  console.log(user.uid, userProfile.uid);
  if (user.uid === userProfile.uid) {

  }
};

socket.on('user taken', onUserTaken);

socket.on('user empty', onUserEmpty);

socket.on('login success', onLoginSuccess);

socket.on('userlist updated', renderUserList);

socket.on('user typing', onUserTyping);
