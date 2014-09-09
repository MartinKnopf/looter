reab =
  ctrl: (ctrlName, sequences) ->
    
    $('[lt-ctrl=' + ctrlName + ']').each(->
      scopeName = $(this).attr('lt-ctrl')
      $scope = $(this)

      ltAttr = (ltAttr, handler) ->
        $scope.find('[' + ltAttr + ']').each(->
          attrVal = $(this).attr(ltAttr)

          bind = (seqName) ->
            if not sequences[seqName] then throw new Error('no sequence named ' + seqName + ' for binding ' + ltAttr + ' in controller ' + ctrlName)
            
            sequences[seqName].subscribe((value) ->
              $scope.find('[' + ltAttr + '="' + attrVal + '"]').each(_.partial(handler, value)))
          
          if _.contains(attrVal, ',')
            _.forEach(attrVal.split(','), bind)
          else
            bind(attrVal)
        )

      ltAttr('lt-text', (value) -> $(this).text(value))
      ltAttr('lt-enabled', (value) -> $(this).prop('disabled', false))
      ltAttr('lt-disabled', (value) -> $(this).prop('disabled', true))
      ltAttr('lt-show', (value) -> $(this).show())
      ltAttr('lt-hide', (value) -> $(this).hide())
    )

root = exports ? this
unless root.reab
  root.reab = reab