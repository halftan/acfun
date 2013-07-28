jQuery ->
  $("#see-password").change ->
    if @checked
      $("#password").prop "type", "text"
    else
      $("#password").prop "type", "password"

