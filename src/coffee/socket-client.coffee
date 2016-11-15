socket = io()
userProfile = {
  uid: ''
  uname: ''
  sid: ''
}

$('#m').on 'keyup', ->
  if $(this).val().length
    socket.emit 'user typing', userProfile

$('form#un-form').submit ->
  socket.emit 'username', $('#un').val()
  $('#un').val ''
  false

$('form#im-form').submit ->
  socket.emit 'chat message', $('#m').val()
  $('#m').val ''
  false

socket.on 'chat message', (username, msg) ->
  $('#messages').append $('<li>').html('<strong>'+username+':</strong> '+msg)
  return

socket.on 'info message', (msg) ->
  $("#messages").append $('<li class="infotext">').html(msg)
  return

#  Login handlers
onUserTaken = ->
  # Display proper toast
  console.log 'username taken'

onUserEmpty = ->
  # Display proper toast
  console.log 'username is empty'

onLoginSuccess = (user) ->
  userProfile = user
  $('form#un-form').fadeOut()

renderUserList = (userList) ->
  $('#user-list').empty()
  for i in [0..userList.length - 1]
    $('#user-list').append $('<li>').html('<strong>'+userList[i].uname+'</strong>') if userList[i].uname

onUserTyping = (user) ->
  console.log user.uid, userProfile.uid
  return if user.uid is userProfile.uid

#  Login hooks
socket.on 'user taken',    onUserTaken
socket.on 'user empty',    onUserEmpty
socket.on 'login success', onLoginSuccess

socket.on 'userlist updated', renderUserList
socket.on 'user typing', onUserTyping