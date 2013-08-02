jQuery ->
  $("#show-password").change ->
    if @checked
      $("#password").prop "type", "text"
    else
      $("#password").prop "type", "password"

  $('input[type="checkbox"]#show-password').checkbox
    buttonStyle: 'btn-danger'
    buttonStyleChecked: 'btn-success'
    checkedClass: 'icon-check'
    uncheckedClass: 'icon-check-empty'

  $('input[type="checkbox"]').checkbox
    buttonStyle: 'btn-link btn-large'
    checkedClass: 'icon-check'
    uncheckedClass: 'icon-check-empty'