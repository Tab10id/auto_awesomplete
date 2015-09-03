((autoAwesomplete, $) ->
  autoAwesomplete.updateList = (awesomplete, path, term) ->
    $.ajax({
      url: path,
      dataType: 'json',
      data: { term: term }
      ,
      success: (data) ->
        awesomplete.list = JSON.parse(data)
        awesomplete.evaluate()
        return
    })

    return

  autoAwesomplete.ajaxInit = ->
    $inputs = $(':not(.awesomplete) > input.auto-ajax-awesomplete')
    $inputs.each ->
      $input = $(this)
      awesomplete = new Awesomplete(this)
      $input.on 'input', ->
        $textInput = $(this)
        path = $textInput.data('awesomplete-href')
        term = $textInput.val()
        autoAwesomplete.updateList(awesomplete, path, term)
        return
      return
    return
  return
) window.autoAwesomplete = window.autoAwesomplete or {}, jQuery

jQuery ($) ->
  autoAwesomplete.ajaxInit()

  $body = $('body')
  $body.on 'ajaxSuccess', ->
    autoAwesomplete.ajaxInit()
    return

  $body.on 'cocoon:after-insert', ->
    autoAwesomplete.ajaxInit()
    return
  return
