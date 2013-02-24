$ ->
  es = new EventSource '/stream'

  es.oneror = (e) ->
    alert 'error!'

  es.onmessage = (e) ->
    d = JSON.parse e.data
    l = $('<li/>').text "[#{d.user} @ #{d.time}] #{d.message}"
    $('#messages').append l

  $('#send').click (e) ->
    $.post '/say',
      user: $('#user').val(), message: $('#message').val()
