szep =
  ctrl: (name, sequences) ->
    $('[lt-ctrl=' + name + ']').each(->
      scopeName = $(this).attr('lt-ctrl')
      $scope = $(this)

      $scope.find('[lt-text]').each(->
        seqName = $(this).attr('lt-text')

        binder = (seqName, attrVal) ->
          if not sequences[seqName] then throw new Error('no sequence named ' + seqName + ' for binding lt-text in controller ' + name)
          sequences[seqName].subscribe((value) ->
            $scope.find('[lt-text="' + attrVal + '"]').each(->
              $(this).text(value)))
      
        if seqName.indexOf(',') >= 0
          _.forEach(seqName.split(','), (seq) ->
            binder(seq, seqName))
        else
          binder(seqName, seqName)
      )

      $scope.find('[lt-enabled]').each(->
        seqName = $(this).attr('lt-enabled')
      
        binder = (seqName, attrVal) ->
          if not sequences[seqName] then throw new Error('no sequence named ' + seqName + ' for binding lt-text in controller ' + name)
          sequences[seqName].subscribe((value) ->
            $scope.find('[lt-enabled="' + attrVal + '"]').each(->
              $(this).prop('disabled', false)))
      
        if seqName.indexOf(',') >= 0
          _.forEach(seqName.split(','), (seq) ->
            binder(seq, seqName))
        else
          binder(seqName, seqName)
      )

      $scope.find('[lt-disabled]').each(->
        seqName = $(this).attr('lt-disabled')
      
        binder = (seqName, attrVal) ->
          if not sequences[seqName] then throw new Error('no sequence named ' + seqName + ' for binding lt-text in controller ' + name)
          sequences[seqName].subscribe((value) ->
            $scope.find('[lt-disabled="' + attrVal + '"]').each(->
              $(this).prop('disabled', true)))
      
        if seqName.indexOf(',') >= 0
          _.forEach(seqName.split(','), (seq) ->
            binder(seq, seqName))
        else
          binder(seqName, seqName)
      )

      $scope.find('[lt-show]').each(->
        seqName = $(this).attr('lt-show')
      
        binder = (seqName, attrVal) ->
          if not sequences[seqName] then throw new Error('no sequence named ' + seqName + ' for binding lt-text in controller ' + name)
          sequences[seqName].subscribe((value) ->
            $scope.find('[lt-show="' + attrVal + '"]').each(->
              $(this).show()))
      
        if seqName.indexOf(',') >= 0
          _.forEach(seqName.split(','), (seq) ->
            binder(seq, seqName))
        else
          binder(seqName, seqName)
      )

      $scope.find('[lt-hide]').each(->
        seqName = $(this).attr('lt-hide')
      
        binder = (seqName, attrVal) ->
          if not sequences[seqName] then throw new Error('no sequence named ' + seqName + ' for binding lt-text in controller ' + name)
          sequences[seqName].subscribe((value) ->
            $scope.find('[lt-hide="' + attrVal + '"]').each(->
              $(this).hide()))
      
        if seqName.indexOf(',') >= 0
          _.forEach(seqName.split(','), (seq) ->
            binder(seq, seqName))
        else
          binder(seqName, seqName)
      )
    )

root = exports ? this
unless root.szep
  root.szep = szep