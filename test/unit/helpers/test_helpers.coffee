
@$it = (text, testFn) ->
  if testFn.length > 0
    it text, (done) ->
      inject ($rootScope) ->
        hasFinished = false
        finish = (err) ->
          hasFinished = true
          done(err)

        testFn(finish)
        # until hasFinished
        #   $rootScope.$digest()
        $rootScope.$digest()
  else
    it text, ->
      inject ($rootScope) ->
        value = testFn()
        $rootScope.$digest()
        value

