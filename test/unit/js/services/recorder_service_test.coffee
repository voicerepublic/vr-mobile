describe "Recorder Service", ->
  #cannot test since native component => cannot find variable: Media
  xit "check Recorder.start()", ->
    inject ($log, Recorder) ->
      Recorder.start()

      expect(Recorder.talkMedia).not.to.be.undefined